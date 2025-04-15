{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../_modules/base.nix
    ../_modules/desktop-base.nix
    ../_modules/desktop-plasma.nix
    ../_modules/containers.nix
    ../_modules/smb-nas.nix
    ../_modules/rustdesk.nix
    ../_modules/work.nix
    ../_modules/vmware-guest.nix
    ./amdgpu.nix
    ./hardware.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_12;

  time.timeZone = "Europe/Berlin";

  users.groups.aurelia = {
    name = "aurelia";
    gid = 1000;
  };
  users.users.aurelia = {
    isNormalUser = true;
    group = "aurelia";
    extraGroups = ["wheel" "docker"];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmjGIsSO9jE85xNPzzp0AWfOSXVL4qQ3cuXeKCvxe+q"];
    shell = pkgs.fish;
  };
  nix.settings.trusted-users = ["aurelia"];
  programs._1password-gui.polkitPolicyOwners = ["aurelia"];

  services.xserver.displayManager.gdm.enable = false;
  services.displayManager = {
    defaultSession = "plasma";
    sddm = {
      # broken with fish
      # https://github.com/NixOS/nixpkgs/issues/287646
      enable = true;
      wayland.enable = true;
    };
  };

  # tiebreaking required if you have gnome+kde
  #programs.ssh.askPassword = lib.mkForce "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # Network
  networking = {
    hostId = "7807e590";
    hostName = "chariot";
    nftables.enable = true;
  };

  # random tools
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.mullvad-vpn.enable = false;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  services.printing.enable = true;

  programs.nix-ld.enable = true;

  services.xrdp = {
    enable = true;
    defaultWindowManager = "startplasma-x11";
    openFirewall = true;
    audio.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
