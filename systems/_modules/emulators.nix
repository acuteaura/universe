{
  pkgs,
  unstable,
  ...
}: {
  environment.systemPackages = with unstable; [
    azahar
    dolphin-emu
    dolphin-emu-primehack
    duckstation
    pcsx2
    pkgs.yuzu.eden
    ppsspp-qt
    rpcs3
    ryubing
    shadps4
    xemu

    (retroarch.withCores (cores:
      with cores; [
        bsnes
        easyrpg
        gambatte
        mgba
        mupen64plus
      ]))

    # https://github.com/NixOS/nixpkgs/issues/418681
    # https://github.com/NixOS/nixpkgs/commit/608422bd4ba434d02278602bc74c46d10bfde2ba
    #emulationstation-de
  ];
}
