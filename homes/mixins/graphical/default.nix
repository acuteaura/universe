{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    appimage-run
    docker-machine-kvm2
    easyeffects
    kitty
    kodi
    obsidian
    peazip
    remmina
    retroarchFull
    rustdesk-flutter
    shotwell
    thunderbird
    virt-manager
    virt-viewer
    vscode
  ];
}
