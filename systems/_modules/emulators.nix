{
  pkgs,
  unstable,
  ...
}: let
  yuzu = pkgs.callPackage ../../packages/yuzu {};
in {
  environment.systemPackages = with unstable; [
    azahar
    ryubing
    pcsx2
    duckstation
    mgba
    melonDS
    rpcs3
    shadps4
    emulationstation-de
    yuzu.eden
  ];
}
