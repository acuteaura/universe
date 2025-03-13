{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  # Booting
  boot.initrd.kernelModules = ["amdgpu"];
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      configurationLimit = 16;
    };
    efi.canTouchEfiVariables = true;
  };
  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "thunderbolt"];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];
  boot.kernelParams = ["amdgpu.sg_display=0" "transparent_hugepage=never"];

  services.power-profiles-daemon.enable = true;

  services.hardware.bolt.enable = true;

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
