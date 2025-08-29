{
  pkgs,
  unstable,
  ...
}: {
  environment.systemPackages = with pkgs; [
  ];

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [thunar-archive-plugin thunar-dropbox-plugin thunar-volman];
  };
}
