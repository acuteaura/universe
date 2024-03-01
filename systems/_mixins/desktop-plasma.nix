{ config, pkgs, ... }:
{
  services.xserver.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    kio-fuse
    krita
    kdePackages.kdenlive
    kdePackages.filelight
    kdePackages.plasma-thunderbolt


    # required for system info
    clinfo
    glxinfo
    vulkan-tools
  ];
}
