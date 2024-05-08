{ config, pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    kio-fuse
    kdePackages.plasma-thunderbolt
    kdePackages.kio
    kdePackages.plasma-vault

    # required for system info
    clinfo
    glxinfo
    vulkan-tools
  ];
}
