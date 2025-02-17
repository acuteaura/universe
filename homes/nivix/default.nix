{ config, pkgs, lib, unstable, ... }:
{
  imports = [
    ../base.nix

    ../_modules/base.nix
    ../_modules/containers.nix
    ../_modules/devops.nix
    ../_modules/hwtools.nix
    ../_modules/kube.nix
    ../_modules/security.nix
    ../_modules/graphical-base.nix
    ../_modules/graphical-personal.nix
    ../_modules/jetbrains.nix
  ];

  home.username = "aurelia";
  home.homeDirectory = "/home/aurelia";

  home.packages = with pkgs; [
    pgadmin4-desktopmode
  ];
}
