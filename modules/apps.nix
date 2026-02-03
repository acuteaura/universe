{
  pkgs,
  lib,
  config,
  ...
}: {
  options.universe.apps = {
    enable = lib.mkEnableOption "Enable default native desktop applications";
  };

  config = lib.mkIf config.universe.apps.enable {
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

    programs.thunar = {
      enable = false;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-dropbox-plugin
        thunar-volman
      ];
    };
  };
}
