{ config, pkgs, unstable, ... }:
{
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    gamemode
    lutris
    mangohud
    protonup-qt
    unstable.protontricks
    winetricks
    wineWowPackages.stable
  ];
}
