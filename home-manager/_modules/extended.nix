{pkgs, ...}: {
  home.packages = with pkgs; [
    ffmpeg
    gnugrep
    gnused
    internetarchive
    openssl
    yt-dlp
  ];
}
