{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../_modules/base.nix
    ../_modules/user-aurelia.nix
    ../_modules/desktop-base.nix
    ../_modules/desktop-gnome.nix
    ../_modules/kvm-guest.nix
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "construct"; # Define your hostname.

  services.displayManager = {
    defaultSession = "gnome";
    gdm.enable = true;
  };

  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;
  services.spice-webdavd.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
