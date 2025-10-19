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
  in if cfg.enable then {
    boot.lanzaboote = {
      enable = false;
      pkiBundle = "/var/lib/sbctl";
    };
  } else {
    # BOOT
    #########################################
    boot.loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        consoleMode = "max";
        rebootForBitlocker = true;
        memtest86.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
