{pkgs, ...}: {
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kdepim-runtime
    elisa
    oxygen
    kwallet
    kwallet-pam
    kwalletmanager
  ];

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
    kdePackages.krecorder
    kio-fuse

    adwaita-icon-theme
    kora-icon-theme
    nordic
    papirus-nord

    # required for system info
    clinfo
    glxinfo
    vulkan-tools
  ];
}
