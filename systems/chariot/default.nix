{pkgs, ...}: {
  imports = [
    ../_mixins/browsers.nix
    ../_mixins/containers.nix
    ../_mixins/mounts.nix

    ../_mixins/user-aurelia.nix

    ./hardware.nix
  ];

  # BOOT
  #########################################
  universe.boot = {
    enable = true;
    secureboot.enable = true;
  };
  boot.plymouth.enable = true;
  boot.zfs.devNodes = "/dev/disk/by-id/";

  universe = {
    kernel = {
      enable = true;
      cachyos = false;
    };
    desktop-plasma.enable = true;
    amdgpu.enable = true;
    libvirt.enable = true;
  };

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
