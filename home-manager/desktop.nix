<<<<<<< Updated upstream
{pkgs, ...}: {
  imports = [
    ./flatpak.nix
  ];

=======
{ pkgs, ... }:
{
>>>>>>> Stashed changes
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
