{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
      bash
      colima
      coreutils
      curl
      docker-client
      gnugrep
      gnused
      lima
      qemu
  ];
}