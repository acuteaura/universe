{ config, pkgs, ... }:
{
  imports = [
    ../_mixins/base.nix
    
    ./hardware-config.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = ["/dev/sda1"];
  boot.initrd.systemd.enable = true;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "thassa";
  networking.domain = "";
  networking.hostId = "05c670f9";
  users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmjGIsSO9jE85xNPzzp0AWfOSXVL4qQ3cuXeKCvxe+q'' ];

  users.users.aurelia = {
    isNormalUser = true;
    extraGroups = [ "wheel" "qemu-libvirtd" ];
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmjGIsSO9jE85xNPzzp0AWfOSXVL4qQ3cuXeKCvxe+q" ];
    shell = pkgs.fish;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
