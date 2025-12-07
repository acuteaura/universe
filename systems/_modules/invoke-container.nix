{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.universe.invokeai-container;

  # RDNA generation to HSA GFX version mapping
  rdnaGfxVersions = {
    rdna1 = "10.1.0";
    rdna2 = "10.3.0";
    rdna3 = "11.0.0";
  };
in {
  options.universe.invokeai-container = {
    # TODO: allow setting USER_ID
    # https://github.com/invoke-ai/InvokeAI/blob/main/docker/docker-entrypoint.sh
    enable = lib.mkEnableOption "Enable Invoke AI container";

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/home/aurelia/.local/share/invoke";
      description = "Base directory for Invoke AI data storage";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "aurelia";
      description = "User that owns the Invoke AI data directory";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "users";
      description = "Group that owns the Invoke AI data directory";
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

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "IP address to bind the Invoke AI container to";
    };

    listenPort = lib.mkOption {
      type = lib.types.port;
      default = 9090;
      description = "Port to expose ComfyUI on the host";
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
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 ${cfg.user} ${cfg.group} -"
    ];

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
        ports = ["${cfg.listenAddress}:${toString cfg.listenPort}:9090"];
        extraOptions = [
          "--device=/dev/kfd"
          "--device=/dev/dri"
          "--ipc=host"
          "--cap-add=SYS_PTRACE"
          "--security-opt=seccomp=unconfined"
        ];
      };
    };
  };
}
