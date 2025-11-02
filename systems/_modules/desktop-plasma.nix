{ pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;

  # i hate amdgpu
  # https://gitlab.freedesktop.org/drm/amd/-/issues/2950
  environment.sessionVariables.KWIN_DRM_NO_AMS = "1";

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    kdepim-runtime
    konsole
    oxygen
    plasma-browser-integration
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
    kwin-effects-forceblur

    # required for system info
    clinfo
    mesa-demos
    vulkan-tools
  ];

  programs.kdeconnect.enable = true;
  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };
}
