{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    coreutils
    ffmpeg
    gnugrep
    gnused
    internetarchive
    openssl
    yt-dlp
  ];
}
