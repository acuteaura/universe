{ config, pkgs, hashedPassword, ... }:
{
  # Time, Dr. Freeman?
  time.timeZone = "Europe/Berlin";

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
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmjGIsSO9jE85xNPzzp0AWfOSXVL4qQ3cuXeKCvxe+q" ];
    shell = pkgs.fish;
  };

  programs._1password-gui.polkitPolicyOwners = [ "aurelia" ];

  services.xserver.displayManager.defaultSession = "plasmawayland";
  services.xserver.displayManager.sddm.enableHidpi = true;

  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  security.pam.services.login.fprintAuth = false;

  boot.extraModprobeConfig = "options thinkpad_acpi experimental=1 fan_control=1";
}
