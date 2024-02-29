{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    age
    chezmoi
    dig
    direnv
    efm-langserver
    fish
    gh
    git
    go
    jq
    ncdu
    neovim
    nixpkgs-fmt
    p7zip
    rclone
    starship
    stress
    tmux
    whois
    yq-go
    zstd
  ];
}
