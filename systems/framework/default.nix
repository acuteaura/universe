{ lib, config, pkgs, unstable, ... }:
{
  imports = [
    ../_mixins/base.nix
    ../_mixins/desktop-base.nix
    #../_mixins/desktop-gnome.nix
    ../_mixins/desktop-plasma.nix
    ../_mixins/games.nix
    ../_mixins/libvirt.nix
    ../_mixins/podman.nix
    ../_mixins/smb-nas.nix
    ../_mixins/work.nix
    ./amdgpu.nix
    ./hardware.nix
  ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  time.timeZone = "Europe/Berlin";

  users.groups.aurelia = {
    name = "aurelia";
    gid = 1000;
  };

  users.users.aurelia = {
    isNormalUser = true;
    group = "aurelia";
    extraGroups = [ "wheel" "libvirtd" ];
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmjGIsSO9jE85xNPzzp0AWfOSXVL4qQ3cuXeKCvxe+q" ];
    shell = pkgs.fish;
  };

  programs._1password-gui.polkitPolicyOwners = [ "aurelia" ];
  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      librewolf
      floorp
    '';
    mode = "644";
  };

  services.xserver.displayManager = {
    defaultSession = "plasma";
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
  #programs.ssh.askPassword = lib.mkForce "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";

  # locally installed packages
  environment.systemPackages = with pkgs; [
    qt6.qtimageformats
  ];

  # broken until everything upgrades electron
  #environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.nix-ld.enable = true;

  # random tools
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
  services.printing.enable = true;
  services.tailscale.enable = true;
  services.xrdp.defaultWindowManager = "plasma";
  services.xrdp.enable = true;
  services.xrdp.openFirewall = true;
  virtualisation.waydroid.enable = true;
}
