{ config, pkgs, ... }:
{
  imports = [
    ../../mixins/base.nix
  ];

  wsl.enable = true;
  wsl.wslConf.network.generateResolvConf = false;
}