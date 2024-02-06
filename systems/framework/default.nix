{ config, pkgs, ... }:
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
  ];

  time.timeZone = "Europe/Berlin";

  users.users.aurelia = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" ];
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
    };
  };

  # locally installed packages
  environment.systemPackages = with pkgs; [
    azure-cli
    blender
    cloudflared
    cool-retro-term
    docker-machine-kvm2
    easyeffects
    element
    flyctl
    jetbrains-toolbox
    kind
    kitty
    kubectl
    kubectx
    minikube
    obsidian
    openssl
    restic
    simh
    thunderbird
    ventoy-full
    virt-viewer
    vscode
    whois
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
