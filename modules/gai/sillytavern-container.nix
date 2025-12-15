{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.universe.gai.sillytavern;
in {
  options.universe.gai.sillytavern = {
    enable = lib.mkEnableOption "Enable SillyTavern container";

    dataDir = lib.mkOption {
      type = lib.types.str;
      description = "Base directory for SillyTavern data storage";
    };

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Automatically start the SillyTavern container on boot";
    };

    image = lib.mkOption {
      type = lib.types.str;
      default = "ghcr.io/sillytavern/sillytavern:latest";
      description = "Docker image to use for SillyTavern";
    };

    extraVolumes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional volume mappings for the SillyTavern container (e.g., [\"/host/path:/container/path\"])";
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Additional environment variables for the SillyTavern container";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services = {
      podman-sillytavern = {
        wantedBy = lib.mkIf config.universe.gai.enableSystemdTarget ["gai.target"];
      };
    };

    virtualisation.oci-containers = {
      backend = "podman";
      containers.sillytavern = {
        autoStart = cfg.autoStart;
        image = "${cfg.image}";
        volumes =
          [
            "${cfg.dataDir}/config:/home/node/app/config"
            "${cfg.dataDir}/data:/home/node/app/data"
            "${cfg.dataDir}/plugins:/home/node/app/plugins"
            "${cfg.dataDir}/extensions:/home/node/app/public/scripts/extensions/third-party"
          ]
          ++ cfg.extraVolumes;
        environment = cfg.extraEnvironment;

        extraOptions = [
          "--network=host"
        ];
      };
    };
  };
}
