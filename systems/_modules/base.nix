{
  pkgs,
  lib,
  ...
}:
{
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_6_15;
  time.timeZone = lib.mkDefault "Europe/Berlin";
  systemd.coredump.enable = lib.mkDefault true;
  zramSwap.enable = lib.mkDefault true;
  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = lib.mkDefault true;
  networking.nftables.enable = lib.mkDefault true;
  networking.firewall.enable = lib.mkDefault true;
  services.resolved.enable = lib.mkDefault true;
  services.tailscale = {
    enable = lib.mkDefault true;
    openFirewall = lib.mkDefault true;
    useRoutingFeatures = lib.mkDefault "client";
  };
  networking.firewall.trustedInterfaces = [ "tailscale*" ];

  programs.nix-index = {
    enable = lib.mkDefault true;
    enableFishIntegration = lib.mkDefault true;
  };
  programs.command-not-found.enable = lib.mkDefault false;

  services.openssh = {
    enable = lib.mkDefault true;
    # require public key authentication for better security
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "yes";
    };
  };

  programs.gnupg.agent.enable = lib.mkDefault true;

  programs.fish = {
    enable = lib.mkDefault true;
    vendor = {
      functions.enable = lib.mkDefault true;
      completions.enable = lib.mkDefault true;
    };
    shellAliases = {
      ls = "exa";
      cat = "bat";
      grep = "rg";
      du = "dust";
      top = "procs";
    };
  };
  programs.zoxide = {
    enable = lib.mkDefault true;
    enableFishIntegration = lib.mkDefault true;
  };

  programs.nix-ld.enable = lib.mkDefault true;
  programs.nix-ld.libraries =
    with pkgs;
    lib.mkDefault [
      icu
      libgcc
      libz
      stdenv.cc.cc.lib
      xorg.libxcb
      zlib
      libgbm
    ];

  # Configure Nix itself
  nix.settings.experimental-features = lib.mkDefault [
    "nix-command"
    "flakes"
  ];
  nix.package = lib.mkDefault pkgs.lix;

  environment.systemPackages = with pkgs; [
    fish

    attic-client
    btop
    cryptsetup
    curl
    dig
    file
    git
    gnupg
    hdparm
    htop
    lzip
    ncdu
    neovim
    nil
    openssl
    p7zip
    pv
    restic
    socat
    sshfs
    tmux
    unar
    wget
    zstd

    # filesystem tools
    btrfs-progs
    e2fsprogs
    exfatprogs
    f2fs-tools
    ntfs3g

    nix-output-monitor

    bat
    dust
    eza
    fd
    fzf
    procs
    ripgrep
    sd
    tmux
    zellij
    zstd

    ghostty.terminfo
  ];
}
