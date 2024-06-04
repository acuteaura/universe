# Only use this set of packages on NixOS with a matching branch!
# Mesa has become very reliant on matching versions...

{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    appimage-run
    blender
    brave
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
    kdePackages.krecorder
    kdePackages.neochat
    obsidian
    quassel
    remmina
    ryujinx
    seafile-client
    shotwell
    signal-desktop
    sqlitebrowser
    strawberry
    thunderbird
    chromium
    virt-manager
    virt-viewer
    vlc
    vscode
    wezterm
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
