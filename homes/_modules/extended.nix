{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    act
    azure-cli
    btop
    docker-compose
    ffmpeg
    gnumake
    hcloud
    hyfetch
    internetarchive
    nmap
    openssl
    opentofu
    powertop
    sqlite
    whois
    yt-dlp
  ];
}
