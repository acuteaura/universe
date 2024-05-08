# Only use this set of packages on NixOS with a matching branch!
# Mesa has become very reliant on matching versions...

{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    appimage-run
    blender
    cool-retro-term
    cryptomator
    cryptomator
    easyeffects
    firefox
    foliate
    gparted
    handbrake
    haruna
    inkscape
    insomnia
    kdePackages.kdenlive
    kdePackages.koko
    obsidian
    quassel
    remmina
    ryujinx
    seafile-client
    shotwell
    signal-desktop
    sqlitebrowser
    strawberry
    telegram-desktop
    thunderbird
    chromium
    virt-manager
    virt-viewer
    vlc
    vscode

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
