{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    protonup-qt
    protonplus
    (bottles.override {removeWarningPopup = true;})
  ];
}
