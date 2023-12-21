{ config, pkgs, hashedPassword, ... }:
{
  imports = [
    ../../base.nix
    ./tranquility.nix
    ./tlp.nix
    ./gpu.nix
    ../../mixins/codium.nix
    ../../mixins/desktop-base.nix
    ../../mixins/desktop-plasma.nix
    ../../mixins/work.nix
  ];
}
