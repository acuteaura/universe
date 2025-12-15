{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.universe.gai.comfyui;

  # RDNA generation to HSA GFX version mapping
  rdnaGfxVersions = {
    rdna1 = "10.1.0";
    rdna2 = "10.3.0";
    rdna3 = "11.0.0";
  };

  # Get video group GID from system config
  videoGid = toString config.users.groups.video.gid;
in {
  options.universe.gai.comfyui = {
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
        autoStart = cfg.autoStart;
        image = cfg.image;
        environment = cfg.extraEnvironment;
        volumes = [
          "${cfg.dataDir}:/home/ubuntu"
        ];
        ports = cfg.portMappings;
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

    systemd.services.podman-comfyui = {
      wantedBy = lib.mkIf config.universe.gai.enableSystemdTarget ["gai.target"];
    };
  };
}
