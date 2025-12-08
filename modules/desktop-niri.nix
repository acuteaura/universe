{
  pkgs,
  lib,
  config,
  ...
}: {
  options.universe.desktop-niri.enable = with lib; mkEnableOption "Enable Niri desktop environment";

  config = lib.mkIf config.universe.desktop-niri.enable {
    # Enable desktop-base by default when niri is enabled
    universe.desktop-base.enable = lib.mkDefault true;

    programs.niri.enable = true;

    environment.systemPackages = with pkgs; [
      fuzzel
      waybar
      mako
      xwayland-satellite
    ];
  };
}
