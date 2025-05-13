{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    gamemode
    mangohud

    unigine-superposition
    unigine-valley
    phoronix-test-suite

    moonlight-qt
  ];
  hardware.xpadneo.enable = lib.mkDefault false;

  programs.steam = {
    enable = true;
    protontricks.enable = true;
    gamescopeSession.enable = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}
