{
  pkgs,
  constants,
  lib,
  config,
  ...
}: let
  cfg = config.universe.serviceContainers.comfyui;
in {
  options.universe.serviceContainers.comfyui = {
    enable = lib.mkEnableOption "Enable ComfyUI container";

    dataDir = lib.mkOption {
      type = lib.types.str;
      description = "Base directory for ComfyUI data storage";
    };

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Automatically start the ComfyUI container on boot";
    };

    image = lib.mkOption {
      type = lib.types.str;
      default = "ghcr.io/acuteaura/comfyui-docker-rocm";
      description = "Docker image to use for ComfyUI";
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
      containers.comfyui = {
        serviceName = "comfyui";
        autoStart = cfg.autoStart;
        image = cfg.image;
        environment = cfg.extraEnvironment;
        volumes = [
          "${cfg.dataDir}:/home/ubuntu"
        ];
        ports = [
          "${constants.tailscale.ip.fool}:8188:8188"
        ];
        extraOptions = [
          "--device=/dev/kfd"
          "--device=/dev/dri"
          "--group-add=video"
          "--ipc=host"
          "--cap-add=SYS_PTRACE"
          "--cap-add=SYS_ADMIN"
          "--security-opt=seccomp=unconfined"
          "--network=host"
        ];
      };
    };
  };
}
