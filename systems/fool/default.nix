{
  lib,
  config,
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
    ../_modules/games.nix
    ../_modules/work.nix
    ./amdgpu.nix
    ./hardware.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_12;

  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      configurationLimit = 16;
    };
    efi.canTouchEfiVariables = true;
  };
  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.hardware.bolt.enable = true;

  # Network
  networking = {
    hostId = "e4d619e1";
    hostName = "fool";
    nftables.enable = true;
  };

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
  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
    '';
    mode = "644";
  };

  services.displayManager = {
    defaultSession = "plasma";
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  # tiebreaking required if you have gnome+kde
  #programs.ssh.askPassword = lib.mkForce "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";

  #systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
