{
  config,
  pkgs,
  ...
}: {
  # Configure Nix itself
  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.networkmanager = {
    enable = true;
  };
  services.resolved.enable = true;
  services.tailscale.enable = true;

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.command-not-found.enable = false;

  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "yes";
    };
  };

  environment.systemPackages = with pkgs; [
    fish

    btrfs-progs
    curl
    cryptsetup
    dig
    e2fsprogs
    git
    htop
    ncdu
    neovim
    pv
    restic
    socat
    tmux
    wget
    zstd
  ];

  programs.fish.enable = true;

  hardware.keyboard.qmk.enable = true;

  nix.package = pkgs.lix;

  # Copy the NixOS configuration file and link it from the resulting system
}
