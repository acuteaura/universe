{pkgs, ...}: {
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
}
