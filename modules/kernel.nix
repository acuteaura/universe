{
  pkgs,
  lib,
  config,
  ...
}: {
  options.universe.kernel = {
    enable =
      lib.mkEnableOption "Enable universe kernel configuration"
      // {
        default = false;
      };
    cachyos = lib.mkEnableOption "Enable CachyOS kernel with ZFS";
  };

  config = lib.mkIf config.universe.kernel.enable {
    boot.kernelPackages =
      if config.universe.kernel.cachyos
      then pkgs.linuxPackages_cachyos
      else pkgs.linuxPackages_6_18;
    boot.zfs.package =
      if config.universe.kernel.cachyos
      then pkgs.zfs_cachyos
      else pkgs.zfs_2_4;
    environment.systemPackages = with pkgs; [
      sanoid
    ];
  };
}
