{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    act
    azure-cli
    btop
    dmidecode
    docker-compose
    ffmpeg
    gnumake
    guestfs-tools
    hcloud
    hyfetch
    internetarchive
    nmap
    openssl
    opentofu
    pciutils
    powertop
    s-tui
    socat
    sqlite
    tcpdump
    tshark
    flyctl
    whois
  ];
}
