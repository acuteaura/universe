{
  pkgs,
  lib,
  unstable,
  ...
}:
{
  # desktops need to be responsive
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";

  # might be needed for xwayland?
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.desktopManager.xterm.enable = false;

  services.flatpak.enable = true;
  services.flatpak.remotes = [ ]; # just use the user one

  services.displayManager = {
    defaultSession = lib.mkDefault "plasma";
    sddm = {
      enable = lib.mkDefault true;
      wayland.enable = lib.mkDefault true;
    };
  };

  # Enable desktop hardware features
  services.pulseaudio.enable = lib.mkDefault false;
  security.rtkit.enable = lib.mkDefault true;
  services.pipewire = {
    enable = lib.mkDefault true;
    alsa.enable = lib.mkDefault true;
    alsa.support32Bit = lib.mkDefault true;
    pulse.enable = lib.mkDefault true;
    jack.enable = lib.mkDefault false;
  };
  hardware.bluetooth.enable = lib.mkDefault true;
  # hardware.bluetooth.settings = {
  #   General = {
  #     ControllerMode = "bredr";
  #   };
  # };

  # prevents AirPods being stolen back by bluez when requesting connection elsewhere
  hardware.bluetooth.settings.Policy.ReconnectAttempts = 0;

  # Ancillary services
  services.pcscd.enable = lib.mkDefault true;
  services.gvfs.enable = lib.mkDefault true;
  services.tumbler.enable = lib.mkDefault true;

  services.avahi = {
    nssmdns4 = lib.mkDefault true;
    openFirewall = lib.mkDefault true;
  };

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    cups-filters
    cups-browsed
    epson-escpr2
    epson-escpr
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
  programs.seahorse.enable = true;
  programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    zenity
    wayland-utils
    wl-clipboard-rs
    libsecret
    nwg-look
    mission-center
    seafile-client
    seafile-shared
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
    sane-airscan
  ];
  environment.etc."sane.d/airscan.conf".text = ''
    # Disable auto-discovery since scanner is in different broadcast domain
    [options]
    discovery = disable

    # Epson ET-2850 configuration
    [devices]
    "Epson ET-2850" = https://192.168.12.81/eSCL/, eSCL
  '';
  services.udev.packages = [pkgs.sane-airscan];

  hardware.keyboard.qmk.enable = true;

  security.sudo-rs.enable = true;
  security.pam.services.sudo.nodelay = true;
  security.pam.services.sudo.failDelay = {
    enable = true;
    delay = 200000; # us -> 2 seconds
  };

  xdg.portal = {
    enable = lib.mkDefault true;
    xdgOpenUsePortal = lib.mkDefault true;
    config = {
      common = {
        default = [
          "kde"
          "gtk"
          "gnome"
        ];
        "org.freedesktop.impl.portal.Secret" = [
          "gnome-keyring"
        ];
      };
    };
  };

  services.power-profiles-daemon.enable = lib.mkDefault true;
  services.thermald.enable = lib.mkDefault true;

  services.hardware.bolt.enable = lib.mkDefault true;
  networking.firewall.trustedInterfaces = [ "thunderbolt*" ];
}
