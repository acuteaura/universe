{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    age
    binwalk
    btop
    chezmoi
    coreutils
    dig
    direnv
    file
    fish
    git
    hyfetch
    jq
    just
    rclone
    restic
    ripgrep
    semgrep
    socat
    starship
    syncthing
    tmux
    whois
    yq-go
    zstd

    neovim
    efm-langserver
  ];
}
