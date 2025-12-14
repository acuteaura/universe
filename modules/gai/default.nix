{
  lib,
  config,
  ...
}: let
  cfg = config.universe.gai;
in {
  imports = [
    ./comfyui-container.nix
    ./invoke-container.nix
    ./koboldcpp-container.nix
    ./ollama-container.nix
    ./sillytavern-container.nix
    ./tailscale-sidecar.nix
  ];

  options.universe.gai = {
    enableSystemdTarget = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the gai.target systemd target for managing all GAI services";
    };
  };

  config = lib.mkIf cfg.enableSystemdTarget {
    systemd.targets.gai = {
      description = "Generative AI Services";
      wantedBy = []; # Don't auto-start with system, manual control only
    };
  };
}
