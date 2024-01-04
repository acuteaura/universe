{ config, pkgs, ... }:
{
  imports = [
    ../../mixins/base.nix
    ../../mixins/desktop-base.nix
    ../../mixins/desktop-plasma.nix
    ../../mixins/work.nix
    ../../mixins/vfio_nvidia.nix
    ./lambdacore.nix
    ./gpu.nix
  ];
}
