{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    age
    btop
    chezmoi
    dig
    direnv
    fish
    git
    hyfetch
    jq
    ncdu
    openssh
    openssl
    p7zip
    rclone
    restic
    ripgrep
    socat
    starship
    tmux
    whois
    yq-go
    zstd

    neovim
    efm-langserver
  ];
}
