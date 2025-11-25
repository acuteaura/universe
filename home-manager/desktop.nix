{pkgs, ...}: {
  imports = [
    ./flatpak.nix
  ];

  home.packages = with pkgs; [
    typst
  ];

  home.file.".config/kwalletrc".text = ''
    [Wallet]
    Enabled=false
  '';
}
