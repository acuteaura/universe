{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wineWowPackages.stable
    winetricks
    gnome.zenity
    protontricks
    lutris
  ];
}
