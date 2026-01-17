{ pkgs, ... }:
{
  imports = [
    ../_mixins/browsers.nix
    ../_mixins/containers.nix
    ../_mixins/hhd.nix
    ../_mixins/mounts.nix

    ../_mixins/user-aurelia.nix

    ./hardware.nix
    ./smb.nix
  ];

  universe = {
    kernel = {
      enable = true;
      cachyos = false;
    };
    boot = {
      enable = true;
      secureboot.enable = true;
    };
    desktop-plasma.enable = true;
    amdgpu.enable = true;
  };
  services.power-profiles-daemon.enable = false;

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

  boot.kernelParams = [
    "i2c-hid.polling_mode=1"
  ];

  networking = {
    hostId = "5934b829";
    hostName = "cyberdaemon";
  };

  # super broken :(
  virtualisation.waydroid.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
