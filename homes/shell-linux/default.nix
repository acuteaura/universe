{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../base.nix

    ../_modules/base.nix
    ../_modules/extended.nix
    ../_modules/containers.nix
    ../_modules/devops.nix
    ../_modules/hwtools.nix
    ../_modules/kube.nix
    ../_modules/security.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "aurelia";
  home.homeDirectory = "/home/aurelia";
}
