{ config, pkgs, ... }:
{
  imports = [
    ../_modules/base.nix
    ../_modules/jetbrains.nix

    ./hardware-config.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "thassa";
  networking.domain = "";
  networking.hostId = "05c670f9";
  users.users.root.openssh.authorizedKeys.keys = [ ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmjGIsSO9jE85xNPzzp0AWfOSXVL4qQ3cuXeKCvxe+q'' ];

  users.users.aurelia = {
    isNormalUser = true;
    extraGroups = [ "wheel" "qemu-libvirtd" ];
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmjGIsSO9jE85xNPzzp0AWfOSXVL4qQ3cuXeKCvxe+q" ];
    shell = pkgs.fish;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    openssl
    libcap
  ];

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 2302 27016 ];
  };

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  programs._1password.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
