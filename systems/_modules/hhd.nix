{
  pkgs,
  lib,
  config,
  ...
}: {
  services.handheld-daemon = {
    user = "aurelia";
    enable = true;
    ui.enable = true;
  };
  boot.extraModulePackages = [config.boot.kernelPackages.acpi_call];
  services.power-profiles-daemon.enable = lib.mkForce false;
}
