{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.universe.comfyui-container;

  # RDNA generation to HSA GFX version mapping
  rdnaGfxVersions = {
    rdna1 = "10.1.0";
    rdna2 = "10.3.0";
    rdna3 = "11.0.0";
  };
in {
  options.universe.comfyui-container = {
    enable = lib.mkEnableOption "Enable ComfyUI container";

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/home/aurelia/.local/share/comfyui";
      description = "Base directory for ComfyUI data storage";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "aurelia";
      description = "User that owns the ComfyUI data directory";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "users";
      description = "Group that owns the ComfyUI data directory";
    };

    rdnaGeneration = lib.mkOption {
      type = lib.types.enum ["rdna1" "rdna2" "rdna3"];
      default = "rdna3";
      description = "RDNA GPU generation for HSA_OVERRIDE_GFX_VERSION";
    };

    useAPU = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Set to true to use APU/GPU 0 only (HIP_VISIBLE_DEVICES=0)";
    };

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Automatically start the ComfyUI container on boot";
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "IP address to bind the ComfyUI container to";
    };

    listenPort = lib.mkOption {
      type = lib.types.port;
      default = 8188;
      description = "Port to expose ComfyUI on the host";
    };

    image = lib.mkOption {
      type = lib.types.str;
      default = "yanwk/comfyui-boot:rocm";
      description = "Docker image to use for ComfyUI";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/storage 0755 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/models 0755 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/hf-hub 0755 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/torch-hub 0755 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/input 0755 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/output 0755 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/workflows 0755 ${cfg.user} ${cfg.group} -"
    ];

    virtualisation.oci-containers = {
      backend = "podman";
      containers.comfyui = {
        autoStart = cfg.autoStart;
        image = cfg.image;
        environment =
          {
            HSA_OVERRIDE_GFX_VERSION = rdnaGfxVersions.${cfg.rdnaGeneration};
          }
          // (
            if cfg.useAPU
            then {HIP_VISIBLE_DEVICES = "0";}
            else {}
          );
        volumes = [
          "${cfg.dataDir}/storage:/root"
          "${cfg.dataDir}/models:/root/ComfyUI/models"
          "${cfg.dataDir}/hf-hub:/root/.cache/huggingface/hub"
          "${cfg.dataDir}/torch-hub:/root/.cache/torch/hub"
          "${cfg.dataDir}/input:/root/ComfyUI/input"
          "${cfg.dataDir}/output:/root/ComfyUI/output"
          "${cfg.dataDir}/workflows:/root/ComfyUI/user/default/workflows"
        ];
        ports = ["${cfg.listenAddress}:${toString cfg.listenPort}:8188"];
        extraOptions = [
          "--device=/dev/kfd"
          "--device=/dev/dri"
          "--group-add=video"
          "--ipc=host"
          "--cap-add=SYS_PTRACE"
          "--security-opt=seccomp=unconfined"
        ];
      };
    };
  };
}
