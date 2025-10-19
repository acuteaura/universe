{pkgs, config, ...}: {
  services.handheld-daemon = {
    user = "aurelia";
    enable = true;
    ui.enable = true;
  };
  boot.extraModulePackages = [ config.boot.kernelPackages.acpi_call ];
}
