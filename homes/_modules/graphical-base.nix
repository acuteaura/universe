# Only use this set of packages on NixOS with a matching branch!
# Mesa has become very reliant on matching versions...

{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    appimage-run
    brave
    cryptomator
    easyeffects
    firefox
    haruna
    inkscape
    insomnia    
    kdePackages.koko
    kdePackages.krecorder
    obsidian
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
}
