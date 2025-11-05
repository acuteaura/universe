{pkgs, ...}: {
  imports = [
    ../_modules/base.nix
    ../_modules/desktop-base.nix
    ../_modules/desktop-plasma.nix

    ../_modules/apps-flatpak.nix
    ../_modules/apps.nix
    ../_modules/browsers.nix
    ../_modules/containers.nix
    ../_modules/emulators.nix
    ../_modules/games.nix
    ../_modules/libvirt.nix
    ../_modules/mounts.nix
    ../_modules/sunshine
    ../_modules/wine.nix

    ../_modules/kernel.nix

    ../_modules/user-aurelia.nix
    ../_modules/amdgpu.nix

    #../_modules/work.nix

    ./gpu-tweaks.nix
    ./hardware.nix
    ./vfio.nix
    ./smb.nix
  ];

  # BOOT
  #########################################
  boot.loader = {
    systemd-boot = {
      enable = false;
      configurationLimit = 10;
      consoleMode = "max";
      rebootForBitlocker = true;
      memtest86.enable = true;
    };
    efi.canTouchEfiVariables = true;
  };
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;

  boot.zfs.devNodes = "/dev/disk/by-id/";
  boot.zfs.extraPools = [
    "nm790"
    "sn850x"
  ];

  # Limit ZFS ARC to 16GB max (instead of the broken auto-detect of 61GB on 64GB system)
  # This prevents OOM kills when running VMs + K8s + desktop
  # Using kernelParams instead of extraModprobeConfig to ensure params are set during initrd
  boot.kernelParams = [
    "zfs.zfs_arc_max=17179869184"  # 16 GiB
    "zfs.zfs_arc_min=4294967296"   # 4 GiB
  ];

  boot.kernelModules = [
    "coretemp"
    "nct6775"
  ];

  universe.cachyos-kernel.enable = true;
  universe.desktop-plasma.enable = true;

  # Network
  networking = {
    hostId = "e4d619e1";
    hostName = "fool";
  };

  # random tools
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
  universe.sunshine.enable = true;

  vfio.enable = false;

  virtualisation.waydroid.enable = true;
  programs.adb.enable = true;

  networking.networkmanager.enable = false;
  networking.networkmanager.unmanaged = [
    "virbr0"
    "docker0"
  ];

  networking = {
    useDHCP = false;
    useNetworkd = true;
    tempAddresses = "disabled";
  };
  services.resolved = {
    enable = true;
    fallbackDns = [];
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
          DHCP = "yes";
          IgnoreCarrierLoss = "yes";
        };
        dhcpV4Config = {
          UseDNS = true;
        };
        linkConfig = {
          MACAddress = "08:bf:b8:19:16:f5";
          RequiredForOnline = "carrier";
        };
      };
    };
  };

  programs.steam.gamescopeSession.args = [
    "--expose-wayland"
    "-e" # Enable steam integration
    "--steam"
    "--adaptive-sync"
    "-r 240"
    "--hdr-enabled"
    "--hdr-itm-enable"
    #  DP output
    "--prefer-output DP-2"
  ];

  nix.settings.system-features = [
    "benchmark"
    "big-parallel"
    "kvm"
    "nixos-test"
    "gccarch-znver4"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
