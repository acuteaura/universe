{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    appimage-run
    blender
    cool-retro-term
    cryptomator
    easyeffects
    firefox
    handbrake
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
    vscode
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
