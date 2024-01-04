{ config, pkgs, unstable, ... }:
{
  # Configure Nix itself
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  networking.networkmanager = {
    enable = true;
  };
  services.resolved.enable = true;
  services.openssh.enable = true;
  services.tailscale.enable = true;

  # Useful!
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  virtualisation.libvirtd = {
    enable = true;
    onShutdown = "shutdown";
    onBoot = "ignore";
  };

  environment.systemPackages = with pkgs; [
    # how much is it?
    fish

    # cli tools
    age
    btop
    chezmoi
    direnv
    dig
    gh
    git
    htop
    jq
    ncdu
    neovim
    rclone
    starship
    s-tui
    stress
    toolbox
    wget
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

