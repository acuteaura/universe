{ config, pkgs, lib, ... }:
{
  # Time, Dr. Freeman?
  time.timeZone = "Europe/Berlin";

  # Booting
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
    };
    efi.canTouchEfiVariables = true;
    plymouth.enable = false;
  };

  # Network
  networking = {
    hostId = "cab93498";
    hostName = "lambdacore";
  };

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

  services.xserver.videoDrivers = [ "amdgpu" ];
  
  hardware.opengl = {
    driSupport = true; # This is already enabled by default
    driSupport32Bit = true; # For 32 bit applications
  };

  /* boot.initrd.availableKernelModules = [ "ata_piix" "mptspi" "uhci_hcd" "ehci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];

  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ]; */

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
      device = "/dev/disk/by-uuid/24D7-DDBE";
      fsType = "vfat";
    };


  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
