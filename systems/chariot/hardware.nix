{...}: {
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "thunderbolt"];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];
  boot.kernelParams = ["amdgpu.sg_display=0" "transparent_hugepage=never"];

  services.power-profiles-daemon.enable = true;

  # supposedly needed for brightness
  # https://github.com/NixOS/nixos-hardware/blob/106d3fec43bcea19cb2e061ca02531d54b542ce3/framework/13-inch/common/default.nix
  hardware.sensor.iio.enable = true;

  boot.zfs.devNodes = "/dev/disk/by-label/";

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/LBOOT";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/" = {
    device = "chariot/root";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "chariot/home";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "chariot/nix";
    fsType = "zfs";
  };

  swapDevices = [];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  services.fwupd.enable = true;
}
