# Only use this set of packages on NixOS with a matching branch!
# Mesa has become very reliant on matching versions...

{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    archivebox
    blender
    cool-retro-term
    discord
    foliate
    guestfs-tools
    handbrake
    kdePackages.kdenlive
    qmk
    seafile-client
    shotwell
    simh
    ventoy-full
  ];
}
