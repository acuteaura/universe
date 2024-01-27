{ config, pkgs, unstable, ... }:
{
  # Configure Nix itself
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.networkmanager = {
    enable = true;
  };
  services.resolved.enable = true;
  services.openssh.enable = true;
  services.tailscale.enable = true;

  # Useful!
  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.command-not-found.enable = false;

  environment.systemPackages = with pkgs; [
    # how much is it?
    fish

    # cli tools
    age
    btop
    chezmoi
    dig
    direnv
    dmidecode
    ffmpeg
    gh
    git
    go
    htop
    jq
    ncdu
    neovim
    p7zip
    pciutils
    powertop
    rclone
    s-tui
    starship
    stress
    toolbox
    usbutils
    wget
    whois
    yq-go
    zstd

    # dev crap
    efm-langserver
    nixpkgs-fmt

    # kde would like to know
    clinfo
    glxinfo
    vulkan-tools
  ];

  programs.fish.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
}

