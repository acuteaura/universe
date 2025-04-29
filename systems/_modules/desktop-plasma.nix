{pkgs, ...}: {
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    qt6.qtimageformats

    kio-fuse
    kdePackages.filelight
    kdePackages.kdeconnect-kde
    kdePackages.kio
    kdePackages.partitionmanager
    kdePackages.plasma-thunderbolt
    kdePackages.plasma-vault

    # required for system info
    clinfo
    glxinfo
    vulkan-tools
  ];
}
