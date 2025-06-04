{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    gamemode
    mangohud
    heroic
    steamtinkerlaunch
  ];
  hardware.xpadneo.enable = lib.mkDefault false;

  programs.steam = {
    enable = true;
    protontricks.enable = true;
    gamescopeSession.enable = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}
