{ config, pkgs, unstable, ... }:
{
  home.packages = with pkgs; [
    azure-cli
    flyctl
    gh
    hcloud
    opentofu
    act
    nixpkgs-fmt
    gnumake
    go
    sqlite
  ];
}
