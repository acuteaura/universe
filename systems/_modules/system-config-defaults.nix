{
  pkgs,
  lib,
  ...
}: {
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_6_14;
  time.timeZone = lib.mkDefault "Europe/Berlin";
  systemd.coredump.enable = lib.mkDefault true;
  zramSwap.enable = lib.mkDefault true;
}
