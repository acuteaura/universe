{ config, pkgs, ... }:
{
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma5.useQtScaling = false;

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    khelpcenter
    plasma-browser-integration
  ];
  environment.systemPackages = with pkgs; [
    kio-fuse
    krita
    libsForQt5.kdenlive
    libsForQt5.filelight
    libsForQt5.plasma-thunderbolt


    # required for system info
    clinfo
    glxinfo
    vulkan-tools
  ];
}
