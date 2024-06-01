{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    distrobox
    docker-machine-kvm2
    dmidecode
    age-plugin-yubikey
    pciutils
    powertop
    s-tui
    usbutils
  ];
}