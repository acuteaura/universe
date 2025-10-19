{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    mangohud
    heroic
    steamtinkerlaunch
    lsfg-vk
    lsfg-vk-ui
  ];
  hardware.xpadneo.enable = lib.mkDefault false;
  hardware.steam-hardware.enable = lib.mkDefault true;
  programs.gamemode.enable = lib.mkDefault true;

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
}
