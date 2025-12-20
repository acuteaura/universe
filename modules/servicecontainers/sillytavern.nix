{
  pkgs,
  lib,
  config,
  constants,
  ...
}: let
  cfg = config.universe.serviceContainers.sillytavern;
in {
  options.universe.serviceContainers.sillytavern = {
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
    virtualisation.oci-containers = {
      backend = "podman";
      containers.sillytavern = {
        serviceName = "sillytavern";
        autoStart = cfg.autoStart;
        image = "${cfg.image}";
        ports = ["${constants.tailscale.ip.fool}:14000:8000"];
        volumes =
          [
            "${cfg.dataDir}/config:/home/node/app/config"
            "${cfg.dataDir}/data:/home/node/app/data"
            "${cfg.dataDir}/plugins:/home/node/app/plugins"
            "${cfg.dataDir}/extensions:/home/node/app/public/scripts/extensions/third-party"
          ]
          ++ cfg.extraVolumes;
        environment = cfg.extraEnvironment;

        extraOptions = [];
      };
    };
  };
}
