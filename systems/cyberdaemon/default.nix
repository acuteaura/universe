{pkgs, ...}: {
  imports = [
    ../_modules/default.nix

    ../_modules/browsers.nix
    ../_modules/containers.nix
    ../_modules/hhd.nix
    ../_modules/libvirt.nix
    ../_modules/mounts.nix

    ../_modules/user-aurelia.nix

    ./hardware.nix
    ./smb.nix
  ];

  universe = {
    cachyos-kernel.enable = false;
    secureboot.enable = true;
    desktop-plasma.enable = true;
    amdgpu.enable = true;
  };

  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;
  boot.plymouth.extraConfig = ''
    [Daemon]
    DeviceScale=2
  '';

  boot.zfs.devNodes = "/dev/disk/by-id/";
  #boot.zfs.extraPools = [];

  boot.kernelModules = [
    "coretemp"
    "nct6775"
  ];

  networking = {
    hostId = "5934b829";
    hostName = "cyberdaemon";
  };

  jovian = {
    steam = {
      enable = true;
      autoStart = false;
      updater.splash = "jovian";
      user = "aurelia";
    };
    decky-loader.enable = true;
    devices = {
      steamdeck.enable = false;
    };
    hardware.has.amd.gpu = false;
    steamos = {
      enableAutoMountUdevRules = false;
    };
  };
  programs.steam.gamescopeSession.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
