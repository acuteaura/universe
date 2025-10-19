{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./containers/keycloak.nix

    ../_modules/base.nix

    ./nginx.nix
    ./hardware-config.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  networking.useDHCP = lib.mkDefault true;

  networking.hostName = "bootstrap";
  networking.domain = "nullvoid.space";

  users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmjGIsSO9jE85xNPzzp0AWfOSXVL4qQ3cuXeKCvxe+q''];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  users.users.aurelia = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmjGIsSO9jE85xNPzzp0AWfOSXVL4qQ3cuXeKCvxe+q"];
    shell = pkgs.fish;
  };

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  programs._1password.enable = true;

  fileSystems."/data" = {
    device = "/dev/disk/by-id/scsi-0HC_Volume_103515584";
    fsType = "ext4";
    options = ["nofail" "x-systemd.device-timeout=10s"];
  };

  # nixos sucks tbh
  networking.firewall.interfaces."podman*".allowedUDPPorts = [53 5353];

  boot.loader.systemd-boot.configurationLimit = 5;
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "-d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
