{ config, pkgs, lib, ... }:
{
  imports = [
    ../mixins/base
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "aurelia";
  home.homeDirectory = "/home/aurelia";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    age
    chezmoi
    dig
    direnv
    efm-langserver
    ffmpeg
    gh
    git
    go
    internetarchive
    jq
    ncdu
    neovim
    nixpkgs-fmt
    p7zip
    powertop
    rclone
    rustdesk-flutter
    starship
    stress
    toolbox
    usbutils
    whois
    yq-go
    zstd

    retroarchFull

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
