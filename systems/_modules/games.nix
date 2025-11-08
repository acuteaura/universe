{
  pkgs,
  lib,
  config,
  ...
}: {
  options.universe.games = {
    enable = lib.mkEnableOption "Enable gaming applications";
  };

  config = lib.mkIf config.universe.games.enable {
    environment.systemPackages = with pkgs; [
      mangohud
      heroic
      steamtinkerlaunch
      lsfg-vk
      lsfg-vk-ui
    ];
    system.userActivationScripts.steamtinkerlaunchCompatAdd.text = ''
      ${pkgs.steamtinkerlaunch}/bin/steamtinkerlaunch compat add
    '';
    hardware.xpadneo.enable = lib.mkDefault false;
    hardware.steam-hardware.enable = lib.mkDefault true;
    programs.gamemode.enable = lib.mkDefault true;

    environment.sessionVariables = {
      MESA_SHADER_CACHE_MAX_SIZE = "10G";
    };

    programs.steam = {
      enable = lib.mkDefault true;
      protontricks.enable = lib.mkDefault true;
      localNetworkGameTransfers.openFirewall = lib.mkDefault true;
      gamescopeSession = {
        enable = lib.mkDefault true;
        args = lib.mkDefault [
          "--expose-wayland"
          "-e" # Enable steam integration
        ];
      };
    };
  };
}
