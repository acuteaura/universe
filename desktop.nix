{ config, pkgs, unstable, ... }:
{
  # Yep, it's a desktop!
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.desktopManager.xterm.enable = false;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    gnome-music
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];


  # Enable desktop hardware features
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;

  # Flatpak wants these
  services.flatpak.enable = true;

  # Ancillary services
  services.pcscd.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.globalprotect = {
    enable = true;
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
  };
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  environment.systemPackages = with pkgs; [
    # gui apps
    globalprotect-openconnect
    seafile-client
    tailscale
    telegram-desktop
    signal-desktop
    slack
    xfce.thunar
    unstable.ungoogled-chromium
    unstable.vscode-fhs
    virt-manager

    # cursed
    wineWowPackages.stable
    winetricks

    # gnome
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnome.adwaita-icon-theme
    adw-gtk3
    unstable.gradience
    gnomeExtensions.blur-my-shell

    # fonts
    inter
    victor-mono
  ];

}
