{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    bash
    colima
    coreutils
    curl
    docker-client
    docker-compose
    docker-buildx
    docker-credential-helpers
    gnugrep
    gnused
    lima
    qemu
  ];
}
