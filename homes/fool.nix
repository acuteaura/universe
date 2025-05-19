{pkgs, ...}: {
  imports = [
    ./base.nix

    ./_modules/base.nix
    ./_modules/containers.nix
    ./_modules/devops.nix
    ./_modules/hwtools.nix
    ./_modules/kube.nix
    ./_modules/security.nix
  ];

  home.username = "aurelia";
  home.homeDirectory = "/home/aurelia";

  home.packages = with pkgs; [
    azure-cli
  ];
}
