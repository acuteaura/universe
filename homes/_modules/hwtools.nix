{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    dmidecode
    pciutils
    powertop
    s-tui
    stress
    usbutils
  ];
}
