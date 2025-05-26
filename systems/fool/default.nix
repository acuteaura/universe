{pkgs, ...}: {
  imports = [
    ../_modules/base.nix
    ../_modules/containers.nix
    ../_modules/desktop-base.nix
    ../_modules/desktop-plasma.nix
    ../_modules/libvirt.nix
    ../_modules/smb-nas.nix
    ../_modules/wine.nix
    ../_modules/work.nix
    ../_modules/system-config-defaults.nix
    ../_modules/user-aurelia.nix
    ../_modules/amdgpu.nix

    ../_modules/emulators.nix
    ../_modules/games.nix
    ../_modules/sunshine

    ../_modules/apps.nix

    ./gpu-tweaks.nix
    ./hardware.nix
    ./vfio.nix
    ./smb.nix
    ./wecontinue.nix
  ];

  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      configurationLimit = 16;
      useOSProber = true;
    };
    efi.canTouchEfiVariables = true;
  };
  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;
  boot.zfs.devNodes = "/dev/disk/by-id/";
  boot.zfs.extraPools = ["magician" "priestress"];

  # Network
  networking = {
    hostId = "e4d619e1";
    hostName = "fool";
    nftables.enable = true;
  };

  services.displayManager = {
    defaultSession = "plasma";
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  services.sunshine-with-virtdisplay.enable = true;

  services.power-profiles-daemon.enable = true;
  services.hardware.bolt.enable = true;

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
  programs.nix-ld.libraries = with pkgs; [
    icu
    libgcc
    zlib
  ];

  vfio.enable = false;

  programs.kdeconnect.enable = true;
  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
    trustedInterfaces = ["br0"];
  };

  hardware.cpu.amd.ryzen-smu.enable = true;

  virtualisation.waydroid.enable = true;
  programs.adb.enable = true;
  services.ollama = {
    enable = true;
    loadModels = ["devstral" "deepseek-r1:14b"];
    acceleration = "rocm";
  };
  services.open-webui.enable = true;
  networking.networkmanager.unmanaged = ["virbr0" "docker0"];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
