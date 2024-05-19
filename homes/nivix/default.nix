{ config, pkgs, lib, ... }:
{
  imports = [
    ../base.nix

    ../_modules/base.nix
    ../_modules/containers.nix
    ../_modules/devops.nix
    ../_modules/hwtools.nix
    ../_modules/kube.nix
    ../_modules/security.nix
    ../_modules/graphical.nix
    ../_modules/jetbrains.nix
  ];

  home.username = "aurelia";
  home.homeDirectory = "/home/aurelia";

  home.packages = with pkgs; [
    archivebox
    guestfs-tools
    qmk
    simh
    ventoy-full
  ];
}
