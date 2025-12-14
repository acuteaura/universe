{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.universe.gai.koboldcpp;
in {
  options.universe.gai.koboldcpp = {
    enable = lib.mkEnableOption "Enable KoboldCpp container";

    dataDir = lib.mkOption {
      type = lib.types.str;
      description = "Directory for KoboldCpp data storage (models, etc.)";
    };

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Automatically start the KoboldCpp container on boot";
    };

    portMappings = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Port mappings for the container (e.g., [\"127.0.0.1:5001:5001\"]). Empty when using Tailscale.";
      example = ["127.0.0.1:5001:5001"];
    };

    image = lib.mkOption {
      type = lib.types.str;
      default = "docker.io/koboldai/koboldcpp:latest";
      description = "Docker image to use for KoboldCpp";
    };

    useTailscaleSidecar = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use Tailscale sidecar for networking (network_mode: container:tailscale-sidecar)";
    };

    extraArgs = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Extra arguments to pass to KoboldCpp via KCPP_ARGS environment variable";
      example = "--usevulkan --threads 6";
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Additional environment variables for the KoboldCpp container";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers = {
      backend = "podman";
      containers.koboldcpp = {
        autoStart = cfg.autoStart;
        image = "${cfg.image}";

        volumes = [
          "${cfg.dataDir}:/workspace"
        ];

        ports = cfg.portMappings;

        environment =
          {
            KCPP_ARGS = cfg.extraArgs;
            KCPP_DONT_TUNNEL = "true";
            KCPP_DONT_UPDATE = "true";
          }
          // cfg.extraEnvironment;

        extraOptions =
          [
            "--device=/dev/kfd"
            "--device=/dev/dri"
            "--group-add=video"
            "--ipc=host"
            "--cap-add=SYS_PTRACE"
            "--security-opt=seccomp=unconfined"
          ]
          ++ (lib.optionals cfg.useTailscaleSidecar [
            "--network=container:tailscale-sidecar"
          ]);
      };
    };

    # Ensure Tailscale sidecar is running before this container starts
    systemd.services.podman-koboldcpp =
      {
        wantedBy = lib.mkIf config.universe.gai.enableSystemdTarget ["gai.target"];
      }
      // lib.optionalAttrs cfg.useTailscaleSidecar {
        requires = ["podman-tailscale-sidecar.service"];
        after = ["podman-tailscale-sidecar.service"];
      };
  };
}
