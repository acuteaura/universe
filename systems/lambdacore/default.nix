{ config, pkgs, ... }:
{
  imports = [
    ../../mixins/base.nix
    ../../mixins/desktop-base.nix
    ../../mixins/desktop-plasma.nix
    ../../mixins/work.nix
    ./vfio.nix
    ./gpu.nix
    ./lambdacore.nix
  ];

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    vscode-fhs
    ffmpeg
    radeontop
    vlc
    p7zip
    protontricks
    element
  ];
}
