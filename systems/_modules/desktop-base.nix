{
  pkgs,
  lib,
  ...
}: {
  # desktops need to be responsive
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";

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
  hardware.bluetooth.settings = {
    General = {
      ControllerMode = "bredr";
    };
  };

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
    wayland-utils
    wl-clipboard-rs
    libsecret
    seahorse
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

  hardware.keyboard.qmk.enable = true;

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
    mode = "0755";
  };

  environment.etc."brave/policies/managed/anti-eich-aktion.json" = {
    text = ''
      {
        "BraveAIChatEnabled": 0,
        "BraveRewardsDisabled": 1,
        "BraveVPNDisabled": 1,
        "BraveWalletDisabled": 1,
        "ExtensionInstallForcelist": [
          "cdglnehniifkbagbbombnjghhcihifij",
          "aeblfdkhhhdcdjpifhhbdiojplfjncoa",
          "hdokiejnpimakedhajhdlcegeplioahd",
          "cjpalhdlnbpafiamejdnhcphjbkeiagm"
        ],
        "IPFSEnabled": false,
        "TorDisabled": 1
      }
    '';
  };

  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [
          "kde"
          "gtk"
          "gnome"
        ];
      };
    };
  };

  services.hardware.bolt.enable = lib.mkDefault true;
  networking.firewall.trustedInterfaces = ["thunderbolt*"];
}
