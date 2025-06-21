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
    yuzu.eden

    # https://github.com/NixOS/nixpkgs/issues/418681
    # https://github.com/NixOS/nixpkgs/commit/608422bd4ba434d02278602bc74c46d10bfde2ba
    #emulationstation-de
  ];
}
