{ config, pkgs, agenix, hmgctl, ... }:
{
  imports = [
    ../../mixins/base.nix
    ../../mixins/desktop-base.nix
    ../../mixins/desktop-plasma.nix
    ../../mixins/games.nix
    ../../mixins/podman.nix
    ../../mixins/work.nix
    ./amdgpu.nix
    ./hardware.nix
    ./libvirt.nix
    ./nvidia.nix
    ./vfio.nix
  ];

  time.timeZone = "Europe/Berlin";

  users.users.aurelia = {
    isNormalUser = true;
    extraGroups = [ "wheel" "qemu-libvirtd" ];
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmjGIsSO9jE85xNPzzp0AWfOSXVL4qQ3cuXeKCvxe+q" ];
    shell = pkgs.fish;
  };

  programs._1password-gui.polkitPolicyOwners = [ "aurelia" ];

  services.xserver.displayManager = {
    defaultSession = "plasmawayland";
    gdm = {
      enable = false;
    };
    sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
    };
  };

  # locally installed packages
  environment.systemPackages = with pkgs; let
    cloudflared = pkgs.cloudflared.overrideAttrs (old: rec {
      version = "2024.1.5";
      src = pkgs.fetchFromGitHub {
        owner = "cloudflare";
        repo = "cloudflared";
        rev = "refs/tags/2024.1.5";
        hash = "sha256-T+hxNvsckL8PAVb4GjXhnkVi3rXMErTjRgGxCUypwVA=";
      };
    });
  in [
    blender
    cool-retro-term
    docker-machine-kvm2
    easyeffects
    element
    kitty
    minikube
    obsidian
    simh
    thunderbird
    ventoy-full
    virt-viewer
    vscode

    cloudflared

    azure-cli
    hmgctl
    kubectl
    kubectx
    whois

    agenix.packages.x86_64-linux.default
  ];

  # broken until everything upgrades electron
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
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
