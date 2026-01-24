{pkgs, ...}: {
  home.packages = with pkgs; [
    b612
    dm-mono
    ibm-plex
    inter
    michroma
    vegur
    victor-mono
  ];
  fonts.fontconfig.enable = true;
  xdg.configFile."fontconfig/conf.d/10-hm-fonts.conf".force = true;
}
