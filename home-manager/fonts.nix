{pkgs, ...}: {
  home.packages = with pkgs; [
    dm-mono
    b612
  ];
  fonts.fontconfig.enable = true;
  xdg.configFile."fontconfig/conf.d/10-hm-fonts.conf".force = true;
}
