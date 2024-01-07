{ config, pkgs, ... }:
{
  imports = [
    ../../mixins/base.nix
    ../../mixins/desktop-base.nix
    ../../mixins/desktop-plasma.nix
    ../../mixins/wine.nix
    ../../mixins/work.nix
    ./amdgpu.nix
    ./nvidia.nix
    ./vfio.nix
    ./libvirt.nix
    ./lambdacore.nix
  ];

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    cool-retro-term
    element
    gnome.zenity
    kitty
    simh
    thunderbird
  ];
}
