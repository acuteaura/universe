{ config, pkgs, ... }:
{
  # Configure Nix itself
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.networkmanager = {
    enable = true;
  };
  services.resolved.enable = true;
  # begone, eater of wor-- dns packets
  #services.tailscale.enable = true;

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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
}

