{ pkgs, ... }:
{
  imports = [
    ../_modules/base.nix
    ../_modules/desktop-base.nix
    ../_modules/desktop-plasma.nix

    ../_modules/apps-flatpak.nix
    ../_modules/apps.nix
    ../_modules/browsers.nix
    ../_modules/containers.nix
    ../_modules/emulators.nix
    ../_modules/games.nix
    ../_modules/libvirt.nix
    ../_modules/mounts.nix
    ../_modules/kernel.nix
    ../_modules/wine.nix

    ../_modules/user-aurelia.nix
    ../_modules/amdgpu.nix

    ./hardware.nix
  ];

  # BOOT
  #########################################
  boot.loader = {
    systemd-boot = {
      enable = false;
      configurationLimit = 10;
      consoleMode = "max";
      rebootForBitlocker = true;
      memtest86.enable = true;
    };
    efi.canTouchEfiVariables = true;
  };
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;
  boot.zfs.devNodes = "/dev/disk/by-id/";

  universe.cachyos-kernel.enable = true;

  # Network
  networking = {
    hostId = "7807e590";
    hostName = "chariot";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
