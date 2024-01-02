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

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  environment.systemPackages = with pkgs; [
    # gui apps
    firefox
    haruna
    lutris
    mpv
    seafile-client
    signal-desktop
    slack
    tailscale
    telegram-desktop
    unstable.ungoogled-chromium
    virt-manager
    xfce.thunar

    # cursed
    wineWowPackages.stable
    winetricks

    # fonts
    inter
    victor-mono
  ];

}
