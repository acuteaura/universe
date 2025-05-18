{
  config,
  pkgs,
  lib,
  ...
}: {
  # Yep, it's a desktop!
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];
  services.xserver.desktopManager.xterm.enable = false;

  # Enable desktop hardware features
  services.pipewire = {
    enable = lib.mkDefault true;
    alsa.enable = lib.mkDefault true;
    pulse.enable = lib.mkDefault true;
  };
  hardware.bluetooth.enable = lib.mkDefault true;

  # prevents AirPods being stolen back by bluez when requesting connection elsewhere
  hardware.bluetooth.settings.Policy.ReconnectAttempts = 0;

  # Flatpak wants these
  services.flatpak.enable = lib.mkDefault true;

  # Ancillary services
  services.pcscd.enable = lib.mkDefault true;
  services.gvfs.enable = lib.mkDefault true;
  services.tumbler.enable = lib.mkDefault true;

  services.avahi = {
    enable = lib.mkDefault true;
    nssmdns4 = lib.mkDefault true;
    openFirewall = lib.mkDefault true;
  };

  services.printing.enable = lib.mkDefault true;
  services.printing.drivers = with pkgs; [
    epson-escpr
    epson-escpr2
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
  };

  programs.thunar.enable = lib.mkDefault false;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    zenity
  ];

  fonts.packages = with pkgs; [
    # fonts
    ibm-plex
    inter
    victor-mono
    vegur
  ];

  hardware.sane.enable = true;
  hardware.sane.extraBackends = with pkgs; [
    epsonscan2
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
