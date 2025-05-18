{unstable, ...}: {
  environment.systemPackages = with unstable; [
    azahar
    ryubing
    pcsx2
    duckstation
    mgba
    melonDS
    rpcs3
    shadps4
  ];
}
