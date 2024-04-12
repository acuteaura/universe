{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    nmap
    tcpdump
    tshark
  ];
}
