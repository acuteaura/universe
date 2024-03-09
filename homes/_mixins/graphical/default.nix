{ config, pkgs, unstable, ... }:
{
  home.packages = with pkgs; [
    appimage-run
    blender
    bottles
    cool-retro-term
    cryptomator
    docker-machine-kvm2
    easyeffects
    firefox
    floorp
    haruna
    inkscape
    insomnia
    jetbrains.goland
    kodi
    obsidian
    onlyoffice-bin
    peazip
    remmina
    seafile-client
    shotwell
    signal-desktop
    strawberry
    telegram-desktop
    thunderbird
    ungoogled-chromium
    unstable.vscode
    virt-manager
    virt-manager
    virt-viewer
    vlc
  ];

  programs.librewolf = {
    enable = true;
    # Enable WebGL, cookies and history
    settings = {
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "network.cookie.lifetimePolicy" = 0;
    };
  };
}
