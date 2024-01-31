{ config, pkgs, unstable, ... }:
{
  imports = [
    ../../mixins/base.nix
    ../../mixins/desktop-base.nix
    ../../mixins/desktop-plasma.nix
    #../../mixins/desktop-gnome.nix
    ../../mixins/games.nix
    ../../mixins/work.nix
    ../../mixins/code-native.nix
    ./amdgpu.nix
    ./nvidia.nix
    ./vfio.nix
    ./libvirt.nix
    ./lambdacore.nix
  ];

  # locally installed packages
  environment.systemPackages = with pkgs; [
    blender
    cool-retro-term
    easyeffects
    element
    gnome.zenity
    kitty
    simh
    thunderbird
    unstable.obsidian
    ventoy-full
    virt-viewer
  ];

  #environment.sessionVariables.NIXOS_OZONE_WL = "1";
  hardware.xpadneo.enable = true;
  programs.nix-ld.enable = true;

  virtualisation.quadlet = {
    containers = {
      nginx.containerConfig = {
        image = "docker.io/library/nginx:latest";
        networks = [ "internal.network" ];
        ip = "10.0.123.12";
      };
      nginx.serviceConfig.TimeoutStartSec = "60";
    };
    networks = {
      internal.networkConfig.subnets = [ "10.0.123.0/24" ];
    };
  };
}
