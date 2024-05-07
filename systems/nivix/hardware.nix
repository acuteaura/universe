{ config, pkgs, lib, modulesPath, ... }:
{
  # Booting
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
    };
    efi.canTouchEfiVariables = true;
  };
  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "thunderbolt" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ "amdgpu.sg_display=0" "transparent_hugepage=never" ];

  services.power-profiles-daemon.enable = true;

  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = false;

  # supposedly needed for brightness
  # https://github.com/NixOS/nixos-hardware/blob/106d3fec43bcea19cb2e061ca02531d54b542ce3/framework/13-inch/common/default.nix
  hardware.sensor.iio.enable = true;

  services.hardware.bolt.enable = true;

  # Network
  networking = {
    hostId = "758fce08";
    hostName = "nivix";
  };

  boot.zfs.devNodes = "/dev/disk/by-label/";

  fileSystems."/" =
    {
      device = "nivix/root";
      fsType = "zfs";
    };

  fileSystems."/home" =
    {
      device = "nivix/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices = [ ];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  services.fwupd.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
