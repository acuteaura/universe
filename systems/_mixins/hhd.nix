{
  lib,
  config,
  ...
}:
{
  services.handheld-daemon = {
    user = "aurelia";
    enable = true;
    ui.enable = true;
    adjustor = {
      enable = true;
      loadAcpiCallModule = true;
    };
  };
}
