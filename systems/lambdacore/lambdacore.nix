{ config, pkgs, lib, modulesPath, ... }:
{
  # Time, Dr. Freeman?
  time.timeZone = "Europe/Berlin";

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
  boot.plymouth.enable = false;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.zfs.extraPools = [ "tank" ];

  # Network
  networking = {
    hostId = "4fd290e9";
    hostName = "lambdacore";
  };

  boot.zfs.devNodes = "/dev/disk/by-label/";

  fileSystems."/" =
    {
      device = "rpool/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/home" =
    {
      device = "rpool/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/D439-4C78";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Who are you?
  users.users.aurelia = {
    isNormalUser = true;
    extraGroups = [ "wheel" "qemu-libvirtd" ];
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmjGIsSO9jE85xNPzzp0AWfOSXVL4qQ3cuXeKCvxe+q" ];
    shell = pkgs.fish;
  };

  programs._1password-gui.polkitPolicyOwners = [ "aurelia" ];

  services.xserver.displayManager = {
    defaultSession = "plasmawayland";
    sddm.enableHidpi = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
