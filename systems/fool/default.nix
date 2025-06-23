{
  pkgs,
  zen4pkgs,
  ...
}: {
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
      useOSProber = false;
    };
    efi.canTouchEfiVariables = true;
  };
  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;
  boot.zfs.devNodes = "/dev/disk/by-id/";
  boot.zfs.extraPools = ["magician" "priestress" "justice"];

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
    stdenv.cc.cc.lib
    libz
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
  };

  hardware.cpu.amd.ryzen-smu.enable = true;

  #virtualisation.waydroid.enable = true;
  programs.adb.enable = true;
  #services.ollama = {
  #  enable = true;
  #  loadModels = ["devstral" "deepseek-r1:14b"];
  #  acceleration = "rocm";
  #};

  networking.networkmanager.enable = false;
  networking.networkmanager.unmanaged = ["virbr0" "docker0"];

  networking = {
    useDHCP = false;
    useNetworkd = true;
    tempAddresses = "disabled";
  };
  systemd.network = {
    enable = true;
    netdevs = {
      "20-br0" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br0";
        };
      };
    };
    networks = {
      "50-eno1" = {
        matchConfig.Name = "eno1";
        networkConfig.Bridge = "br0";
        linkConfig.RequiredForOnline = "enslaved";
      };
      "60-thunderbolt0" = {
        matchConfig.Name = "thunderbolt0";
        networkConfig.DHCP = "no";
        linkConfig.RequiredForOnline = "no";
      };
      "90-br0" = {
        matchConfig.Name = "br0";
        bridgeConfig = {};
        networkConfig = {
          DHCP = "no";
          Address = "192.168.2.2/24";
          Gateway = "192.168.2.1";
          DNS = "192.168.2.1";
          IgnoreCarrierLoss = "yes";
        };
        linkConfig = {
          MACAddress = "08:bf:b8:19:16:f5";
          RequiredForOnline = "carrier";
        };
      };
    };
  };

  nix.settings.system-features = ["benchmark" "big-parallel" "kvm" "nixos-test" "gccarch-znver4"];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
