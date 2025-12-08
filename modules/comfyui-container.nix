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
      description = "Base directory for ComfyUI data storage";
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

    portMappings = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Port mappings for the container (e.g., [\"127.0.0.1:8188:8188\"]). Empty when using Tailscale.";
      example = ["127.0.0.1:8188:8188"];
    };

    image = lib.mkOption {
      type = lib.types.str;
      default = "yanwk/comfyui-boot:rocm";
      description = "Docker image to use for ComfyUI";
    };

    useTailscaleSidecar = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use Tailscale sidecar for networking (network_mode: container:tailscale-sidecar)";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}/storage 0755 root root -"
      "d ${cfg.dataDir}/models 0755 root root -"
      "d ${cfg.dataDir}/hf-hub 0755 root root -"
      "d ${cfg.dataDir}/torch-hub 0755 root root -"
      "d ${cfg.dataDir}/input 0755 root root -"
      "d ${cfg.dataDir}/output 0755 root root -"
      "d ${cfg.dataDir}/workflows 0755 root root -"
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
        ports = cfg.portMappings;
        extraOptions =
          [
            "--device=/dev/kfd"
            "--device=/dev/dri"
            "--group-add=video"
            "--ipc=host"
            "--cap-add=SYS_PTRACE"
            "--security-opt=seccomp=unconfined"
          ]
          ++ lib.optionals cfg.useTailscaleSidecar [
            "--network=container:tailscale-sidecar"
          ];
      };
    };

    # Ensure Tailscale sidecar is running before this container starts
    systemd.services.podman-comfyui = lib.mkIf cfg.useTailscaleSidecar {
      requires = ["podman-tailscale-sidecar.service"];
      after = ["podman-tailscale-sidecar.service"];
    };
  };
}
