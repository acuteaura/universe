{pkgs, ...}: let
  icon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/kubernetes-sigs/headlamp/1d2e68d710fccbe3688d93dbf9e3657ae3a2f514/docs/images/icon.png";
    hash = "sha256-60bzXPl/VjFyoEtp1jUf4QfG+BtIvuhRKsOZmW3vTrQ=";
  };
  headlamp = pkgs.appimageTools.wrapType2 {
    pname = "headlamp";
    version = "0.30.0";
    src = pkgs.fetchurl {
      url = "https://github.com/kubernetes-sigs/headlamp/releases/download/v0.30.0/Headlamp-0.30.0-linux-x64.AppImage";
      hash = "sha256-S6e0/fUjdJ2Oepv3q+rCT8VnyiwZOm60wOu28a07xHA=";
    };
  };
  headlampDesktopItem = pkgs.makeDesktopItem {
    name = "Headlamp";
    desktopName = "headlamp";
    exec = "${headlamp}/bin/headlamp";
    terminal = false;
    icon = icon;
  };
in {
  environment.systemPackages = [
    headlamp
    headlampDesktopItem
  ];
}
