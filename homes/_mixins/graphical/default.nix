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
    haruna
    inkscape
    insomnia
    kodi
    libreoffice
    localsend
    obsidian
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

    jetbrains.goland
    jetbrains.idea-community
    jetbrains.idea-ultimate
    jetbrains.mps
    jetbrains.pycharm-professional
    jetbrains.rust-rover
    jetbrains.webstorm
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
