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
    litestream
    nixpkgs-fmt
    opentofu
    sqlite
  ];
}
