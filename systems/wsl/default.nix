{ config, pkgs, ... }:
{
  imports = [
    ../../mixins/base.nix
  ]

  wsl.enable = true;
}