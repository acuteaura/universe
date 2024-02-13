{ config, pkgs, ... }:
{
  # Configure Nix itself
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

    htop
    wget
    gnome.zenity

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

