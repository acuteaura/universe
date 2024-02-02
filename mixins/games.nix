{ config, pkgs, ... }:
{
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    gamemode
    lutris
    mangohud
    protonup-qt
    protontricks
    winetricks
    wineWowPackages.stable
  ];
  hardware.xpadneo.enable = true;
}
