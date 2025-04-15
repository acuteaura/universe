{pkgs, ...}: let
  headlamp = pkgs.appimageTools.wrapType2 {
    name = "headlamp";
    src = pkgs.fetchurl {
      url = "https://github.com/kubernetes-sigs/headlamp/releases/download/v0.30.0/Headlamp-0.30.0-linux-x64.AppImage";
      hash = "sha256-S6e0/fUjdJ2Oepv3q+rCT8VnyiwZOm60wOu28a07xHA=";
    };
  };
  headlampDesktopItem = pkgs.makeDesktopItem {
    name = "headlamp";
    desktopName = "headlamp";
    exec = "${headlamp}/bin/headlamp";
    terminal = false;
  };
in {
  home.packages = [
    headlamp
    headlampDesktopItem
  ];
}
