{...}: {
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
    device = "cyberdaemon/root";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "cyberdaemon/home";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "cyberdaemon/nix";
    fsType = "zfs";
  };

  swapDevices = [];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  services.fwupd.enable = true;
}
