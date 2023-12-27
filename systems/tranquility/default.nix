{ config, pkgs, hashedPassword, ... }:
{
  imports = [
    ../../mixins/base.nix
    ../../mixins/codium.nix
    ../../mixins/desktop-base.nix
    ../../mixins/desktop-plasma.nix
    ../../mixins/work.nix
    ./tranquility.nix
    ./tlp.nix
    ./gpu.nix
  ];
}
