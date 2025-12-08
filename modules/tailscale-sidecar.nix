{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.universe.tailscale-sidecar;
in {
  options.universe.tailscale-sidecar = {
    enable = lib.mkEnableOption "Enable Tailscale sidecar container";

    authKeyFile = lib.mkOption {
      type = lib.types.str;
      description = "Path to file containing Tailscale auth key";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      description = "Hostname for this Tailscale node";
    };

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Automatically start the Tailscale sidecar on boot";
    };

    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/tailscale-sidecar";
      description = "Directory for Tailscale state";
    };

    image = lib.mkOption {
      type = lib.types.str;
      default = "tailscale/tailscale:latest";
      description = "Tailscale Docker image to use";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Extra arguments to pass to tailscale up";
      example = ["--ssh" "--advertise-exit-node"];
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.authKeyFile != "";
        message = "tailscale-sidecar: authKeyFile must be set";
      }
    ];

    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0700 root root -"
    ];

    virtualisation.oci-containers = {
      backend = "podman";
      containers.tailscale-sidecar = {
        autoStart = cfg.autoStart;
        image = cfg.image;

        volumes = [
          "${cfg.stateDir}:/var/lib/tailscale"
          "/dev/net/tun:/dev/net/tun"
          "${cfg.authKeyFile}:/run/secrets/tailscale-authkey:ro"
        ];

        environment = {
          TS_AUTHKEY = "file:/run/secrets/tailscale-authkey";
          TS_HOSTNAME = cfg.hostname;
          TS_STATE_DIR = "/var/lib/tailscale";
          TS_EXTRA_ARGS = lib.concatStringsSep " " cfg.extraArgs;
        };

        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--cap-add=NET_RAW"
          "--device=/dev/net/tun"
        ];
      };
    };
  };
}
