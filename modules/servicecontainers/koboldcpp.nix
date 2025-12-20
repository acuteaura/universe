{
  pkgs,
  lib,
  config,
  constants,
  ...
}: let
  cfg = config.universe.serviceContainers.koboldcpp;
in {
  options.universe.serviceContainers.koboldcpp = {
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

    image = lib.mkOption {
      type = lib.types.str;
      description = "Docker image to use for KoboldCpp";
    };

    extraArgs = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Extra arguments to pass to KoboldCpp via KCPP_ARGS environment variable";
      example = {
        usevulkan = "";
        threads = "6";
        host = "0.0.0.0";
      };
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Additional environment variables for the KoboldCpp container";
    };

    extraVolumes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional volume mounts for the KoboldCpp container";
      example = ["/path/on/host:/path/in/container:ro"];
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers = {
      backend = "podman";
      containers.koboldcpp = {
        serviceName = "koboldcpp";
        autoStart = cfg.autoStart;
        image = "${cfg.image}";

        volumes =
          [
            "${cfg.dataDir}:/workspace"
          ]
          ++ cfg.extraVolumes;

        ports = [
          "${constants.tailscale.ip.fool}:14001:5001"
        ];

        environment =
          {
            KCPP_ARGS = lib.concatStringsSep " " (
              lib.mapAttrsToList (key: value:
                if value == ""
                then "--${key}"
                else "--${key} ${value}")
              cfg.extraArgs
            );
            KCPP_DONT_TUNNEL = "true";
            KCPP_DONT_UPDATE = "true";
          }
          // cfg.extraEnvironment;

        extraOptions = [
          "--device=/dev/kfd"
          "--device=/dev/dri"
          "--group-add=video"
          "--ipc=host"
          "--cap-add=SYS_PTRACE"
          "--security-opt=seccomp=unconfined"
          "--user=1000:1000"
        ];
      };
    };
  };
}
