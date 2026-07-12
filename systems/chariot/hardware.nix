_: {
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "thunderbolt"];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];
  boot.kernelParams = ["amdgpu.sg_display=0" "transparent_hugepage=never"];

  services.power-profiles-daemon.enable = true;

  # supposedly needed for brightness
  # https://github.com/NixOS/nixos-hardware/blob/106d3fec43bcea19cb2e061ca02531d54b542ce3/framework/13-inch/common/default.nix
  hardware.sensor.iio.enable = true;

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

  # Disable WiFi power management (mt7921e / MediaTek)
  # Also suppress aggressive BSS roaming via NM config — the driver initiates BSS
  # transitions every ~5 min to a second BSSID, the AP rejects re-association
  # temporarily, and the 3-retry limit causes a full dropout.
  networking.networkmanager.wifi.powersave = false;
  networking.networkmanager.wifi.backend = "iwd";
  networking.networkmanager.settings.connection."wifi.cloned-mac-address" = "stable";
  networking.networkmanager.settings.device."wifi.scan-rand-mac-address" = "no";
  boot.extraModprobeConfig = ''
    options mt7921e disable_aspm=1
  '';
}
