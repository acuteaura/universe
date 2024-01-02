{ config, pkgs, ... }:
{
  imports = [
    ../../mixins/base.nix
    ../../mixins/desktop-base.nix
    ../../mixins/desktop-plasma.nix
    ../../mixins/vmware-guest.nix
    ../../work.nix
    ./lambdacore.nix
  ];
}
