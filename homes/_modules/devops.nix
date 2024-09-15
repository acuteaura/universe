{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    act
    azure-cli
    flyctl
    gh
    gnumake
    go
    hcloud
    nixpkgs-fmt
    opentofu
    sqlite
  ];
}
