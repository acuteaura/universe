{ config, pkgs, ... }:
{
  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.xserver.desktopManager.plasma5.enable = true;

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    khelpcenter
    plasma-browser-integration
  ];
  environment.systemPackages = with pkgs; [
    kio-fuse
  ];
}
