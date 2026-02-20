{pkgs, lib, ...}: {
  home.packages = with pkgs; [
    b612
    dm-mono
    ibm-plex
    inter
    michroma
    vegur
    nerd-fonts.iosevka
    victor-mono
  ];
  fonts.fontconfig.enable = true;
}
