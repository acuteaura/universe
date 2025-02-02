{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    age
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
  ] ++ lib.optionals (pkgs.stdenv.isDarwin) [
    bash
    coreutils
    curl
    gnugrep
    gnused
    qemu
  ] ++ lib.optionals (pkgs.stdenv.isLinux) [
    # broken dependency on darwin: sleuthkit
    # ...because nixpkgs doesn't give a shit about darwin
    binwalk
  ];
}
