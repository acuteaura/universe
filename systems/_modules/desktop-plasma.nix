{pkgs, ...}: {
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kdepim-runtime
    elisa
    oxygen
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
    kdePackages.krecorder
    kio-fuse

    kdePackages.qtstyleplugin-kvantum
    tela-icon-theme
    tela-circle-icon-theme
    (pkgs.callPackage ../../packages/rose-pine-kvantum.nix {})
    rose-pine-cursor
    rose-pine-gtk-theme
    rose-pine-icon-theme

    # required for system info
    clinfo
    glxinfo
    vulkan-tools
  ];
}
