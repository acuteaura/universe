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
      description = "Automatically start the Invoke AI container on boot";
    };

    portMappings = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Port mappings for the container (e.g., [\"127.0.0.1:9090:9090\"]). Empty when using Tailscale.";
      example = ["127.0.0.1:9090:9090"];
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

    useTailscaleSidecar = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use Tailscale sidecar for networking (network_mode: container:tailscale-sidecar)";
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
            HSA_OVERRIDE_GFX_VERSION = rdnaGfxVersions.${cfg.rdnaGeneration};
          }
          // (
            if cfg.useAPU
            then {HIP_VISIBLE_DEVICES = "0";}
            else {}
          );
        volumes =
          [
            "${cfg.dataDir}:/invokeai"
          ]
          ++ cfg.extraVolumes;
        ports = cfg.portMappings;
        extraOptions =
          [
            "--device=/dev/kfd"
            "--device=/dev/dri"
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
    systemd.services.podman-invokeai =
      {
        wantedBy = lib.mkIf config.universe.gai.enableSystemdTarget ["gai.target"];
      }
      // lib.optionalAttrs cfg.useTailscaleSidecar {
        requires = ["podman-tailscale-sidecar.service"];
        after = ["podman-tailscale-sidecar.service"];
      };
  };
}
