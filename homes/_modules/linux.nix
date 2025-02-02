{ config, pkgs, ... }:
{
  home.packages = with pkgs; [

    dmidecode
    age-plugin-yubikey
    pciutils
    powertop
    s-tui
    usbutils
  ];
}
