{ pkgs, ... }:
{
  imports = [
    ./flatpak.nix
  ];

  home.packages = with pkgs; [
    typst
    lmms
    vital
  ];

  home.file.".config/kwalletrc".text = ''
    [Wallet]
    Enabled=false
  '';
}
