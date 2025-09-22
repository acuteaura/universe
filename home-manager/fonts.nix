{pkgs, ...}: {
  home.packages = with pkgs; [
    dm-mono
    b612
  ];
  fonts.fontconfig.enable = true;
}
