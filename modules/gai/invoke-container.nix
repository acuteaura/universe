{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.universe.gai.invokeai;

  # RDNA generation to HSA GFX version mapping
  rdnaGfxVersions = {
    rdna1 = "10.1.0";
    rdna2 = "10.3.0";
    rdna3 = "11.0.0";
  };
in {
  options.universe.gai.invokeai = {
    enable = lib.mkEnableOption "Enable Invoke AI container";

    dataDir = lib.mkOption {
      type = lib.types.str;
      description = "Base directory for Invoke AI data storage";
    };

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Automatically start the Invoke AI container on boot";
    };

    image = lib.mkOption {
      type = lib.types.str;
      default = "ghcr.io/invoke-ai/invokeai:main-rocm";
      description = "Docker image to use for ComfyUI";
    };

    extraVolumes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional volume mappings for the Invoke AI container (e.g., [\"/host/path:/container/path\"])";
      example = ["/mnt/models:/models" "/mnt/output:/output"];
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
      containers.invokeai = {
        autoStart = cfg.autoStart;
        image = cfg.image;
        environment =
          {
            INVOKEAI_ROOT = "/invokeai";
          }
          // cfg.extraEnvironment;
        volumes =
          [
            "${cfg.dataDir}:/invokeai"
          ]
          ++ cfg.extraVolumes;
        extraOptions = [
          "--device=/dev/kfd"
          "--device=/dev/dri"
          "--ipc=host"
          "--cap-add=SYS_PTRACE"
          "--security-opt=seccomp=unconfined"
          "--network=host"
        ];
      };
    };

    systemd.services.podman-invokeai = {
      wantedBy = lib.mkIf config.universe.gai.enableSystemdTarget ["gai.target"];
    };
  };
}
