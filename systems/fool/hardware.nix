{...}: {
  boot.initrd.availableKernelModules = ["nvme" "thunderbolt" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/LBOOT";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/" = {
    device = "fool/root";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "fool/home";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "fool/nix";
    fsType = "zfs";
  };

  # fileSystems."/media/steam-library-magician" = {
  #   device = "magician/steam-library";
  #   fsType = "zfs";
  # };

  # fileSystems."/media/steam-library-empress" = {
  #   device = "empress/steam-library";
  #   fsType = "zfs";
  # };

  # fileSystems."/media/wecontinue" = {
  #   device = "fool/wecontinue";
  #   fsType = "zfs";
  # };

  # fileSystems."/media/epicgames" = {
  #   device = "empress/epicgames";
  #   fsType = "zfs";
  # };

  # fileSystems."/media/msfs" = {
  #   device = "magician/msfs";
  #   fsType = "zfs";
  # };

  swapDevices = [];

  hardware.enableRedistributableFirmware = true;
  #hardware.enableAllFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  services.fwupd.enable = true;
}
