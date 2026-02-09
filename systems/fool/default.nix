{pkgs, ...}: {
  imports = [
    ../_mixins/browsers.nix
    ../_mixins/containers.nix
    ../_mixins/mounts.nix
    ../_mixins/obs-virt.nix

    ../_mixins/user-aurelia.nix
    (builtins.fetchurl {
      url = "https://git.sapphiccode.net/SapphicCode/universe/raw/branch/main/nixos/module/user/sapphiccode.nix";
      sha256 = "sha256-cvIpRrD8HV3XO1FIvU2wTvw9c7iLdJ53XDlnetkuJLM=";
    })

    ./gpu-tweaks.nix
    ./hardware.nix
    ./vfio.nix
    ./smb.nix
    ./vr.nix

    ../_mixins/mlsupport.nix
  ];

  users.users.sapphiccode.extraGroups = ["users"];
  users.users.aurelia.extraGroups = ["users"];

  # BOOT
  #########################################
  universe.boot = {
    enable = true;
    secureboot.enable = true;
  };
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
    "zfs.zfs_arc_max=17179869184" # 16 GiB
    "zfs.zfs_arc_min=4294967296" # 4 GiB
  ];

  boot.kernelModules = [
    "coretemp"
    "nct6775"
  ];

  universe = {
    kernel.enable = true;
    desktop-plasma.enable = true;
    desktop-niri.enable = true;
    amdgpu = {
      enable = true;
    };
    libvirt = {
      enable = true;
    };
    games.fuckUpMyKernelForSteamVR = false;
  };

  # Network
  networking = {
    hostId = "e4d619e1";
    hostName = "fool";
  };

  # random tools
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
  universe.sunshine.enable = true;

  # Disable USB autosuspend for SteelSeries Arctis Nova Pro Wireless
  # This prevents the device from suspending and requiring re-plugging
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1038", ATTR{idProduct}=="12e0", ATTR{power/control}="on"
  '';

  vfio.enable = false;

  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };

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
    settings.Resolve.FallbackDNS = [];
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

  services.zfs = {
    autoScrub = {
      enable = false;
      interval = "monthly";
    };
    autoSnapshot = {
      enable = true;
      weekly = 0;
      monthly = 0;
      daily = 7;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
