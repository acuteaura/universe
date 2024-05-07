{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    age
    binwalk
    btop
    chezmoi
    dig
    direnv
    file
    fish
    git
    hyfetch
    jq
    ncdu
    rclone
    restic
    ripgrep
    semgrep
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
