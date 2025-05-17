{pkgs, ...}: {
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
    pv
    restic
    socat
    tmux
    wget
    zstd
  ];

  programs.gnupg.agent.enable = true;
  programs.fish.enable = true;

  hardware.keyboard.qmk.enable = true;

  nix.package = pkgs.lix;
}
