{...}: {
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "thunderbolt"];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];
  boot.kernelParams = ["amdgpu.sg_display=0" "transparent_hugepage=never"];

  services.power-profiles-daemon.enable = true;

  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = false;

  # supposedly needed for brightness
  # https://github.com/NixOS/nixos-hardware/blob/106d3fec43bcea19cb2e061ca02531d54b542ce3/framework/13-inch/common/default.nix
  hardware.sensor.iio.enable = true;

  boot.zfs.devNodes = "/dev/disk/by-label/";

  fileSystems."/" = {
    device = "chariot/root";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "chariot/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  services.fwupd.enable = true;
}
