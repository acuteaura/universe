{
  pkgs,
  unstable,
  ...
}: {
  home.packages = with pkgs; [
  ];

  home.file.".config/kwalletrc".text = ''
    [Wallet]
    Enabled=false
  '';
}
