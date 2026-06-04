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
  };
}
