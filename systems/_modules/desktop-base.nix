{ config, pkgs, unstable, ... }:
{
  # Yep, it's a desktop!
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.desktopManager.xterm.enable = false;

  # Enable desktop hardware features
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

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
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

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    # common dependency
    zenity
    gparted
    #unstable.zed-editor
  ];

  fonts.packages = with pkgs; [
    # fonts
    ibm-plex
    inter
    victor-mono
    nerdfonts
  ];

  hardware.sane.enable = true;
  hardware.sane.extraBackends = with pkgs; [
    epsonscan2
  ];

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    epson-escpr
    epson-escpr2
  ];

  security.pam.services.sudo.nodelay = true;
  security.pam.services.sudo.failDelay = {
    enable = true;
    delay = 200000;
  };

  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      librewolf
      vivaldi-bin
    '';
    mode = "644";
  };

  services.hardware.bolt.enable = true;
}
