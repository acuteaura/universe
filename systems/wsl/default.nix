{ config, pkgs, ... }:
{
  imports = [
    ../_mixins/base.nix
  ];

  wsl.enable = true;
  wsl.wslConf.network.generateResolvConf = false;
}
