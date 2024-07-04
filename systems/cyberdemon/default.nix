{ lib, config, pkgs, age-plugin-op, ... }:
{
  imports = [
    ../_modules/base.nix
    ../_modules/desktop-base.nix
    ../_modules/desktop-gnome.nix
    ../_modules/games.nix
    ../_modules/containers.nix
    ../_modules/smb-nas.nix
    ../_modules/work.nix
    ./amdgpu.nix
    ./hardware.nix
  ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  time.timeZone = "Europe/Berlin";

  # Network
  networking = {
    hostId = "93515df2";
    hostName = "cyberdemon";
    nftables.enable = true;
  };

  users.groups.aurelia = {
    name = "aurelia";
    gid = 1069;
  };

  users.users.aurelia = {
    uid = 1069;
    isNormalUser = true;
    group = "aurelia";
    extraGroups = [ "wheel" "networkmanager" "input" "lp" "scanner" "dialout" "docker" ];
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmjGIsSO9jE85xNPzzp0AWfOSXVL4qQ3cuXeKCvxe+q" ];
    shell = pkgs.bash;
  };

  users.users.sapphiccode = {
    isNormalUser = true;
    description = "Cassandra";
    extraGroups = [ "wheel" "networkmanager" "input" "lp" "scanner" "dialout" "docker" ];
    shell = pkgs.bash;
  };

  programs.fish.enable = true;
  programs._1password-gui.polkitPolicyOwners = [ "sapphiccode" "aurelia" ];

  services.xserver.displayManager.gdm.enable = true;
  services.displayManager = {
    defaultSession = "gnome";
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
    age-plugin-op
  ];

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # random tools
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
