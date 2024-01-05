{ config, pkgs, ... }:
{
  imports = [
    ../../mixins/base.nix
    ../../mixins/desktop-base.nix
    ../../mixins/desktop-plasma.nix
    ../../mixins/work.nix
    ./vfio_nvidia.nix
    ./gpu.nix
    ./lambdacore.nix
  ];

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    vscode-fhs
  ];
}
