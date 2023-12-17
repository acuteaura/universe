{ config, pkgs, hashedPassword, ... }:
{
  # Booting
  boot.loader.systemd-boot = {
    enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = false;

  # Network
  networking.hostId = "06eff076";
  networking.hostName = "tranquility";

  # Who are you?
  users.users.aurelia = {
    isNormalUser = true;
    hashedPassword = hashedPassword;
    extraGroups = [ "wheel" "qemu-libvirtd" ];
    packages = with pkgs; [
      firefox
      mpv
      haruna
    ];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmjGIsSO9jE85xNPzzp0AWfOSXVL4qQ3cuXeKCvxe+q"];
    shell = pkgs.fish;
  };

  programs._1password-gui.polkitPolicyOwners = [ "aurelia" ];
}