{pkgs, ...}: {
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    qt6.qtimageformats

    kdePackages.filelight
    kdePackages.kdeconnect-kde
    kdePackages.kio
    kdePackages.partitionmanager
    kdePackages.plasma-thunderbolt
    kdePackages.plasma-vault
    kdePackages.powerdevil
    kdePackages.qtstyleplugin-kvantum
    kio-fuse

    # required for system info
    clinfo
    glxinfo
    vulkan-tools
  ];
}
