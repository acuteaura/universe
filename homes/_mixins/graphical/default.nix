{ config, pkgs, unstable, ... }:
{
  home.packages = with pkgs; [
    appimage-run
    blender
    bottles
    cool-retro-term
    docker-machine-kvm2
    easyeffects
    firefox
    haruna
    jetbrains.goland
    kodi
    onlyoffice-bin
    obsidian
    peazip
    remmina
    seafile-client
    shotwell
    signal-desktop
    slack
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
}
