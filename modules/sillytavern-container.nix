{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.universe.sillytavern-container;
in {
  options.universe.sillytavern-container = {
    enable = lib.mkEnableOption "Enable SillyTavern container";

    dataDir = lib.mkOption {
      type = lib.types.str;
      description = "Base directory for SillyTavern data storage";
    };

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Automatically start the SillyTavern container on boot";
    };

    portMappings = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Port mappings for the container (e.g., [\"127.0.0.1:8000:8000\"]). Empty when using Tailscale.";
      example = ["127.0.0.1:8000:8000" "0.0.0.0:8443:8443"];
    };

    image = lib.mkOption {
      type = lib.types.str;
      default = "ghcr.io/sillytavern/sillytavern:latest";
      description = "Docker image to use for SillyTavern";
    };

    enablePlugins = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable server plugins directory";
    };

    enableExtensions = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable global UI extensions directory";
    };

    extraVolumes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional volume mappings for the SillyTavern container (e.g., [\"/host/path:/container/path\"])";
    };

    ssl = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable SSL support using Tailscale certificates";
      };

      hostname = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Tailscale hostname to request certificate for (e.g., hostname.tailnet-name.ts.net)";
      };
    };

    useTailscaleSidecar = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use Tailscale sidecar for networking (network_mode: container:tailscale-sidecar)";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.ssl.enable -> cfg.ssl.hostname != "";
        message = "sillytavern-container: ssl.hostname must be set when ssl.enable is true";
      }
    ];

    systemd.services = {
      sillytavern-tailscale-cert = lib.mkIf cfg.ssl.enable {
        description = "Fetch Tailscale certificate for SillyTavern";
        after = ["network-online.target" "tailscaled.service"];
        wants = ["network-online.target"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          User = "root";
          ExecStart = "${pkgs.writeShellScript "fetch-tailscale-cert" ''
            set -euo pipefail

            # Create certs directory
            mkdir -p ${cfg.dataDir}/certs

            # Fetch certificate from Tailscale
            ${pkgs.tailscale}/bin/tailscale cert \
              --cert-file ${cfg.dataDir}/certs/${cfg.ssl.hostname}.crt \
              --key-file ${cfg.dataDir}/certs/${cfg.ssl.hostname}.key \
              ${cfg.ssl.hostname}

            # Set permissions
            chmod 644 ${cfg.dataDir}/certs/${cfg.ssl.hostname}.crt
            chmod 600 ${cfg.dataDir}/certs/${cfg.ssl.hostname}.key
          ''}";
        };
      };

      podman-sillytavern = lib.mkIf cfg.useTailscaleSidecar {
        requires = ["podman-tailscale-sidecar.service"];
        after = ["podman-tailscale-sidecar.service"];
      };
    };

    systemd.timers = lib.mkIf cfg.ssl.enable {
      sillytavern-tailscale-cert = {
        description = "Renew Tailscale certificate for SillyTavern";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnBootSec = "5m";
          OnUnitActiveSec = "24h";
          Persistent = true;
        };
      };
    };

    virtualisation.oci-containers = {
      backend = "podman";
      containers.sillytavern = {
        autoStart = cfg.autoStart;
        image = "${cfg.image}";
        volumes =
          [
            "${cfg.dataDir}/config:/home/node/app/config"
            "${cfg.dataDir}/data:/home/node/app/data"
          ]
          ++ lib.optionals cfg.enablePlugins [
            "${cfg.dataDir}/plugins:/home/node/app/plugins"
          ]
          ++ lib.optionals cfg.enableExtensions [
            "${cfg.dataDir}/extensions:/home/node/app/public/scripts/extensions/third-party"
          ]
          ++ lib.optionals cfg.ssl.enable [
            "${cfg.dataDir}/certs:/home/node/app/certs:ro"
          ]
          ++ cfg.extraVolumes;
        ports = cfg.portMappings;

        extraOptions = lib.optionals cfg.useTailscaleSidecar [
          "--network=container:tailscale-sidecar"
        ];
      };
    };
  };
}
