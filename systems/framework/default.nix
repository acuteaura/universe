{ config, pkgs, unstable, ... }:
{
  imports = [
    ../mixins/base.nix
    ../mixins/desktop-base.nix
    ../mixins/desktop-plasma.nix
    ../mixins/games.nix
    ../mixins/podman.nix
    ../mixins/work.nix
    ./amdgpu.nix
    ./hardware.nix
    ./libvirt.nix
  ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  services.power-profiles-daemon.enable = true;
  services.fprintd.enable = true;
  hardware.sensor.iio.enable = true;

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
    gnumake
    jetbrains-toolbox
    kind
    kitty
    kubectl
    kubectx
    minikube
    obsidian
    openssl
    restic
    shotwell
    simh
    thunderbird
    ventoy-full
    virt-viewer
    vscode
    whois

    unstable.retroarchFull
    unstable.emulationstation-de
  ];

  # broken until everything upgrades electron
  #environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.nix-ld.enable = true;
  services.mullvad-vpn.enable = true;

  environment.sessionVariables.PLASMA_USE_QT_SCALING = "0";
  /* virtualisation.quadlet.containers.rustdeskHbbs = {
    unitConfig = {
      After = [ "magpie.target" ];
      Wants = [ "magpie.target" ];
      RequiresMountsFor = [
        "/magpie/apps/unifi"
      ];
    };
    containerConfig = {
      image = "docker.io/rustdesk/rustdesk-server:latest";
      exec = "hbbs";
      volumes = [ "/magpie/apps/rustdesk:/data:U" ];
      publishPorts = [
        "21115:21115/tcp"
        "21116:21116/tcp"
        "21116:21116/udp"
        "21118:21118/tcp"
      ];
    };
    };
      
    virtualisation.quadlet.containers.rustdeskHbbr = {
    unitConfig = {
      After = [ "magpie.target" ];
      Wants = [ "magpie.target" ];
      RequiresMountsFor = [
        "/magpie/apps/unifi"
      ];
    };
    containerConfig = {
      image = "docker.io/rustdesk/rustdesk-server:latest";
      exec = "hbbr";
      volumes = [ "/magpie/apps/rustdesk:/data:U" ];
      publishPorts = [
        "21117:21117/tcp"
        "21119:21119/tcp"
      ];
    };
  }; */

}
