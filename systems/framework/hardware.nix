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
  boot.kernelParams = [ "amdgpu.sg_display=0" ];
  security.pam.services.login.fprintAuth = false;

  # Network
  networking = {
    hostId = "758fce08";
    hostName = "framework";
  };

  boot.zfs.devNodes = "/dev/disk/by-label/";

  fileSystems."/" =
    {
      device = "framework/root";
      fsType = "zfs";
    };

  fileSystems."/home" =
    {
      device = "framework/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/90A3-C2DE";
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
