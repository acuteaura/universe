{
  pkgs,
  config,
  lib,
  ...
}: {
  # Configure Nix itself
  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.networkmanager = {
    enable = lib.mkDefault true;
  };
  services.resolved.enable = lib.mkDefault true;
  services.tailscale.enable = lib.mkDefault true;
  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
  };

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
  programs.fish.enable = lib.mkDefault true;
  programs.nix-ld.enable = lib.mkDefault true;
  programs.nix-ld.libraries = with pkgs;
    lib.mkDefault [
      icu
      libgcc
      libz
      stdenv.cc.cc.lib
      xorg.libxcb
      zlib
    ];

  nix.package = lib.mkDefault pkgs.lix;

  environment.systemPackages = with pkgs; [
    fish

    attic-client
    btrfs-progs
    cryptsetup
    curl
    dig
    e2fsprogs
    exfatprogs
    git
    gnupg
    hdparm
    htop
    lzip
    ncdu
    neovim
    ntfs3g
    openssl
    p7zip
    pv
    restic
    socat
    sshfs
    tmux
    unrar-free
    wget
    zstd

    nix-output-monitor
  ];
}
