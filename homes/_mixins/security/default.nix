{ config, pkgs, unstable, ... }:
{
  home.packages = with pkgs; [
    nmap
    tcpdump
    tshark
  ];
}