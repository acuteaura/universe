{
  pkgs,
  lib,
  config,
  options,
  ...
}: let
  hasEden = options ? programs.eden;
in {
  options.universe.emulators = {
    enable = lib.mkEnableOption "Enable emulator applications";
  };

  config = lib.mkIf config.universe.emulators.enable (lib.mkMerge ([
      {
        environment.systemPackages = with pkgs; [
          azahar
          dolphin-emu
          #dolphin-emu-primehack
          pcsx2
          ppsspp-qt
          #rpcs3
          ryubing
          #shadps4
          xemu
          gargoyle

          (retroarch.withCores (
            cores:
              with cores; [
                bsnes
                easyrpg
                gambatte
                mgba
                mupen64plus
              ]
          ))

          # https://github.com/NixOS/nixpkgs/issues/418681
          # https://github.com/NixOS/nixpkgs/commit/608422bd4ba434d02278602bc74c46d10bfde2ba
          #emulationstation-de
          pegasus-frontend
        ];
      }
    ]
    ++ (
      if hasEden
      then [
        {
          programs.eden = {
            enable = true;
            enableCache = true;
          };
        }
      ]
      else []
    )));
}
