{
  pkgs,
  unstable,
  ...
}: {
  environment.systemPackages = with unstable; [
    azahar
    ryubing
    pkgs.yuzu.eden

    # https://github.com/NixOS/nixpkgs/issues/418681
    # https://github.com/NixOS/nixpkgs/commit/608422bd4ba434d02278602bc74c46d10bfde2ba
    #emulationstation-de
  ];
}
