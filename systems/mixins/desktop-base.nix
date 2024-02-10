{ config, pkgs, unstable, ... }:
{
  # Yep, it's a desktop!
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.desktopManager.xterm.enable = false;

  # Enable desktop hardware features
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;

  # prevents AirPods being stolen back by bluez when requesting connection elsewhere
  hardware.bluetooth.settings.Policy.ReconnectAttempts = 0;

  # Flatpak wants these
  services.flatpak.enable = true;

  # Ancillary services
  services.pcscd.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
  };

  programs.steam = {
    enable = true;
  };

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    # gui apps
    firefox
    gnome.zenity
    haruna
    mpv
    seafile-client
    signal-desktop
    slack
    tailscale
    telegram-desktop
    ungoogled-chromium
    unstable.virt-manager
    vlc
    xfce.thunar
  ];

  fonts.packages = with pkgs; [
    # fonts
    ibm-plex
    inter
    victor-mono
  ];
}
