{
  pkgs,
  lib,
  config,
  ...
}: {
  options.universe.desktop-gnome.enable = with lib; mkEnableOption "Enable GNOME desktop environment";

  config = lib.mkIf config.universe.desktop-gnome.enable {
    # Enable desktop-base by default when gnome is enabled
    universe.desktop-base.enable = lib.mkDefault true;

    services.desktopManager.gnome.enable = true;
    environment.gnome.excludePackages = with pkgs; [
      gnome-photos
      gnome-tour
      gnome-music
      epiphany
      geary
      gnome-characters
      tali
      iagno
      hitori
      atomix
    ];

    services.udev.packages = with pkgs; [gnome-settings-daemon];

    environment.systemPackages = with pkgs; [
      adw-gtk3
      adwaita-icon-theme
      gnomeExtensions.appindicator
      gnomeExtensions.blur-my-shell
      gnomeExtensions.dash-to-dock
      gradience
    ];
  };
}
