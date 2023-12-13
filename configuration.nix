# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

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

  # Time, Dr. Freeman?
  time.timeZone = "Europe/Berlin";

  # Yep, it's a desktop!
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.desktopManager.xterm.enable = false;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    gnome-music
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];


  # Enable desktop hardware features
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;

  # Flatpak wants these
  services.flatpak.enable = true;

  # Ancillary services
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  services.pcscd.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Useful!
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  virtualisation.libvirtd.enable = true;

  # Oh god please clean this up
  environment.systemPackages = with pkgs; [
    # how much is it?
    fish

    # gui apps
    globalprotect-openconnect
    seafile-client
    tailscale
    telegram-desktop
    xfce.thunar
    ungoogled-chromium
    unstable.vscode-fhs
    virt-manager

    # gnome
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnome.adwaita-icon-theme
    adw-gtk3
    unstable.gradience
    gnomeExtensions.blur-my-shell

    # cli tools
    age
    btop
    chezmoi
    direnv
    gh
    git
    htop
    jq
    ncdu
    neovim
    rclone
    starship
    toolbox
    wget
    yq-go
    zstd

    # dev crap
    efm-langserver
    nixpkgs-fmt

    # fonts
    inter
    victor-mono

    # kde would like to know
    clinfo
    glxinfo
    vulkan-tools

    # kde would like to kindly screw all your non-KDE apps over
    kio-fuse
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
  };
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  programs.fish.enable = true;
  services.globalprotect = {
    enable = true;
  };

  security.pam.services.login.fprintAuth = false;


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

