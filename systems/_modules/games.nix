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
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession = {
      enable = true;
      args = [
        "--expose-wayland"
        "-e" # Enable steam integration
        "--steam"
        "--adaptive-sync"
        "-r 240"
        "--hdr-enabled"
        "--hdr-itm-enable"
        #  DP output
        "--prefer-output DP-2"
      ];
    };
  };
}
