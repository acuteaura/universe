{
  pkgs,
  lib,
  config,
  ...
}: {
  options.universe.secureboot.enable = with lib;
    mkEnableOption "Enable Lanzaboote";

  config = let
    cfg = config.universe.secureboot.enable;
  in {
    boot = {
      lanzaboote = {
        enable = cfg;
        pkiBundle = "/var/lib/sbctl";
      };
      loader = {
        systemd-boot = {
          enable = !cfg;
          configurationLimit = 10;
          consoleMode = "max";
          rebootForBitlocker = true;
          memtest86.enable = true;
        };
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
