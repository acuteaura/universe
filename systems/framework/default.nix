{ lib, config, pkgs, unstable, ... }:
{
  imports = [
    ../mixins/base.nix
    ../mixins/desktop-base.nix
    ../mixins/desktop-gnome.nix
    ../mixins/desktop-plasma.nix
    ../mixins/games.nix
    ../mixins/libvirt.nix
    ../mixins/podman.nix
    ../mixins/work.nix
    ./amdgpu.nix
    ./hardware.nix
  ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

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
      enable = true;
    };
    sddm = {
      # broken with fish
      # https://github.com/NixOS/nixpkgs/issues/287646
      enable = false;
      wayland.enable = true;
    };
  };

  # tiebreaking required if you have gnome+kde
  programs.ssh.askPassword = lib.mkForce "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";

  # locally installed packages
  environment.systemPackages = with pkgs; [
    # do NOT set to unstable
    # there's a lot of compiling involved if you do
    # TODO: move to home-manager once someone merges nix-profile core support
    # https://github.com/NixOS/nixpkgs/pull/287583
    retroarchFull
    unstable.emulationstation-de
    davinci-resolve
  ];

  # broken until everything upgrades electron
  #environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.nix-ld.enable = true;
  environment.sessionVariables.PLASMA_USE_QT_SCALING = "0";

  # random tools
  services.mullvad-vpn.enable = true;
  virtualisation.waydroid.enable = true;
}
