{
  pkgs,
  lib,
  config,
  ...
}: {
  options.universe.cachyos-kernel.enable = with lib;
    mkEnableOption "Enable CachyOS kernel with ZFS";

  config = let
    cfg = config.universe.cachyos-kernel;
  in {
    boot.kernelPackages = (
      if cfg.enable
      then pkgs.linuxPackages_cachyos-lto
      else pkgs.linuxPackages_6_16
    );
    boot.zfs.package = lib.mkDefault (
      if cfg.enable
      then pkgs.zfs_cachyos
      else pkgs.zfs
    );
  };
}
