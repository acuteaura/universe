{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.universe.ollama-container;
in {
  options.universe.ollama-container = {
    enable = lib.mkEnableOption "Enable Ollama container";

    dataDir = lib.mkOption {
      type = lib.types.str;
      description = "Directory for Ollama data storage (models, etc.)";
    };

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Automatically start the Ollama container on boot";
    };

    portMappings = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Port mappings for the container (e.g., [\"0.0.0.0:11434:11434\"]). Empty when using Tailscale.";
      example = ["127.0.0.1:11434:11434"];
    };

    image = lib.mkOption {
      type = lib.types.str;
      default = "docker.io/ollama/ollama:latest";
      description = "Docker image to use for Ollama";
    };

    useRocm = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use ROCm (AMD GPU) version of Ollama";
    };

    rocmDevices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["/dev/kfd" "/dev/dri"];
      description = "Devices to pass through for ROCm support";
    };

    rdnaGeneration = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum ["rdna2" "rdna3"]);
      default = null;
      description = "RDNA generation for ROCm override (rdna2 or rdna3)";
    };

    useTailscaleSidecar = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use Tailscale sidecar for networking (network_mode: container:tailscale-sidecar)";
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Additional environment variables for the Ollama container";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers = {
      backend = "podman";
      containers.ollama = {
        autoStart = cfg.autoStart;
        image = "${cfg.image}";

        volumes = [
          "${cfg.dataDir}:/root/.ollama"
        ];

        ports = cfg.portMappings;

        environment =
          {
            OLLAMA_HOST = "0.0.0.0:11434";
          }
          // (lib.optionalAttrs (cfg.useRocm && cfg.rdnaGeneration != null) {
            HSA_OVERRIDE_GFX_VERSION =
              if cfg.rdnaGeneration == "rdna2"
              then "10.3.0"
              else if cfg.rdnaGeneration == "rdna3"
              then "11.0.0"
              else "";
          })
          // cfg.extraEnvironment;

        extraOptions =
          (lib.optionals cfg.useRocm (
            map (device: "--device=${device}") cfg.rocmDevices
          ))
          ++ (lib.optionals cfg.useTailscaleSidecar [
            "--network=container:tailscale-sidecar"
          ]);
      };
    };

    # Ensure Tailscale sidecar is running before this container starts
    systemd.services.podman-ollama = lib.mkIf cfg.useTailscaleSidecar {
      requires = ["podman-tailscale-sidecar.service"];
      after = ["podman-tailscale-sidecar.service"];
    };
  };
}
