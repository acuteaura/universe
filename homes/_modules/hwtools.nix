{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    age-plugin-yubikey
    dmidecode
    pciutils
    powertop
    s-tui
    stress
    usbutils
    yubikey-manager
  ];
}
