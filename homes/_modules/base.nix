{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    age
    btop
    chezmoi
    curl
    dig
    direnv
    file
    fish
    git
    hyfetch
    iperf
    jq
    just
    rclone
    restic
    ripgrep
    socat
    starship
    syncthing
    tmux
    whois
    yq-go
    zellij
    zstd

    efm-langserver
    micro
    neovim
  ] ++ lib.optionals (pkgs.stdenv.isDarwin) [
    bash
    qemu
  ] ++ lib.optionals (pkgs.stdenv.isLinux) [
    # broken dependency on darwin: sleuthkit
    # ...because nixpkgs doesn't give a shit about darwin
    binwalk
  ];
}
