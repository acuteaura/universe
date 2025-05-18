{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  # Network
  networking = {
    hostId = "5934b829";
    hostName = "cyberdaemon";
    nftables.enable = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  boot.zfs.devNodes = "/dev/disk/by-label/";

  fileSystems."/" = {
    device = "cyberboot/root";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "cyberboot/home";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "cyberboot/nix";
    fsType = "zfs";
  };

  swapDevices = [];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  services.fwupd.enable = true;
}
