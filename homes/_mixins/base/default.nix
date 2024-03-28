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
    neovim
    openssh
    openssl
    p7zip
    rclone
    restic
    socat
    starship
    tmux
    whois
    yq-go
    zstd

    nvim
    efm-langserver
  ];
}
