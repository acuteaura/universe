{ config, pkgs, hashedPassword, ... }:
{
  imports = [
    ../../mixins/base.nix
    ../../mixins/code-native.nix
    ../../mixins/desktop-base.nix
    ../../mixins/desktop-plasma.nix
    ../../mixins/work.nix
    ./tranquility.nix
    ./tlp.nix
    ./gpu.nix
  ];
}
