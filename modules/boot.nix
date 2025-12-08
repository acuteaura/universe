{
  pkgs,
  lib,
  config,
  options,
  ...
}: let
  hasLanzaboote = options ? boot.lanzaboote;
in {
  options.universe.boot = {
    enable = lib.mkEnableOption "Enable universe boot configuration" // {default = false;};
    secureboot.enable = lib.mkEnableOption "Enable Lanzaboote for secure boot";
  };

  config = lib.mkIf config.universe.boot.enable (lib.mkMerge ([
      {
        boot.loader = {
          systemd-boot = {
            enable = lib.mkDefault true;
            configurationLimit = 10;
            consoleMode = "max";
            rebootForBitlocker = true;
            memtest86.enable = true;
          };
          efi.canTouchEfiVariables = true;
        };
      }
    ]
    ++ (
      if hasLanzaboote
      then [
        (lib.mkIf config.universe.boot.secureboot.enable {
          boot.lanzaboote = {
            enable = true;
            pkiBundle = "/var/lib/sbctl";
          };
          boot.loader.systemd-boot.enable = lib.mkForce false;
        })
      ]
      else []
    )));
}
