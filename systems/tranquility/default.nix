{ config, pkgs, hashedPassword, ... }:
{
  imports = [
    ./tranquility.nix
    ./tlp.nix
    ./gpu.nix
    ../../mixins/codium.nix
    ../../mixins/desktop-base.nix
    ../../mixins/desktop-gnome.nix
    ../../mixins/work.nix
  ];
}
