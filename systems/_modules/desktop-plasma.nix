{pkgs, ...}: {
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    qt6.qtimageformats

    kdePackages.filelight
    kdePackages.kdeconnect-kde
    kdePackages.kio
    kdePackages.krfb
    kdePackages.partitionmanager
    kdePackages.plasma-thunderbolt
    kdePackages.plasma-vault
    kdePackages.powerdevil
    kdePackages.qtstyleplugin-kvantum
    kio-fuse

    adwaita-icon-theme
    kora-icon-theme
    nordic

    # required for system info
    clinfo
    glxinfo
    vulkan-tools
  ];
}
