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
    tmux
    unrar-free
    wget
    zstd
  ];

  programs.gnupg.agent.enable = lib.mkDefault true;
  programs.fish.enable = lib.mkDefault true;
  programs.nix-ld.enable = lib.mkDefault true;

  nix.settings = {
    substituters = ["https://attic.nullvoid.space/default"];
    trusted-public-keys = ["default:LZHLvF1j4Aees2xS1uEAN7ZJ/IacERC/77qkSV1G8fw="];
  };

  nix.package = lib.mkDefault pkgs.lix;
}
