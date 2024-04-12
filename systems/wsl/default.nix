{ config, pkgs, ... }:
{
  imports = [
    ../_modules/base.nix
  ];

  wsl.enable = true;
  wsl.wslConf.network.generateResolvConf = false;
}
