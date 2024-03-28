{ config, pkgs, unstable, ... }:
{
  home.packages = with pkgs; [
    distrobox
    docker-compose
  ];
}