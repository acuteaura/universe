{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    docker-machine-kvm2
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