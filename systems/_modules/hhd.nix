{pkgs, ...}: {
  services.handheld-daemon = {
    user = "aurelia";
    enable = true;
    ui.enable = true;
    package = pkgs.handheld-daemon.override {
      extraDependencies = [pkgs.adjustor];
    };
  };
}
