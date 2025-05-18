{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../_modules/amdgpu.nix
    ../_modules/base.nix
    ../_modules/containers.nix
    ../_modules/desktop-base.nix
    ../_modules/desktop-plasma.nix
    ../_modules/libvirt.nix
    ../_modules/smb-nas.nix
    ../_modules/wine.nix
    ../_modules/work.nix
    ../_modules/xrdp.nix
    ../_modules/system-config-defaults.nix
    ../_modules/user-aurelia.nix

    ../_modules/apps.nix

    ./hardware.nix
  ];

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

  services.xserver.displayManager.gdm.enable = false;
  services.displayManager = {
    defaultSession = "plasma";
    sddm = {
      # broken with fish
      # https://github.com/NixOS/nixpkgs/issues/287646
      enable = true;
      wayland.enable = true;
    };
  };

  # Network
  networking = {
    hostId = "7807e590";
    hostName = "chariot";
    nftables.enable = true;
  };

  services.pipewire.enable = lib.mkForce false;
  hardware.pulseaudio.enable = lib.mkForce true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
