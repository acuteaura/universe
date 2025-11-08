{
  pkgs,
  lib,
  config,
  ...
}: {
  options.universe.wine = {
    enable = lib.mkEnableOption "Enable Wine and related applications";
  };

  config = lib.mkIf config.universe.wine.enable {
    environment.systemPackages = with pkgs; [
      protonup-qt
      protonplus
      umu-launcher
    ];
  };
}
