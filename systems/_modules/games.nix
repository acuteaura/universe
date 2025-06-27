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
  hardware.steam-hardware.enable = true;

  programs.steam = {
    enable = true;
    protontricks.enable = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession = {
      enable = lib.mkDefault true;
      args = lib.mkDefault [
        "--expose-wayland"
        "-e" # Enable steam integration
      ];
    };
  };
}
