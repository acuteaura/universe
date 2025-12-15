{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.universe.gai.ollama;
in {
  options.universe.gai.ollama = {
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

    image = lib.mkOption {
      type = lib.types.str;
      default = "docker.io/ollama/ollama:rocm";
      description = "Docker image to use for Ollama";
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

        environment =
          {
            OLLAMA_HOST = "0.0.0.0:11434";
          }
          // cfg.extraEnvironment;

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

    systemd.services.podman-ollama = {
      wantedBy = lib.mkIf config.universe.gai.enableSystemdTarget ["gai.target"];
    };
  };
}
