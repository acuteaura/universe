{
  pkgs,
  ...
}: let
  aptakube = pkgs.appimageTools.wrapType2 {
    name = "aptakube";
    src = pkgs.fetchurl {
      url = "https://releases.aptakube.com/aptakube_1.11.3_amd64.AppImage";
      hash = "sha256-6gPuLJOQGqjfyDcjox+xenaAEvzCSbgiDOE311JCv44=";
    };
  };
  aptakubeDesktopItem = pkgs.makeDesktopItem {
    name = "aptakube";
    desktopName = "Aptakube";
    exec = "${aptakube}/bin/aptakube";
    terminal = false;
  };
in {
  home.packages = [
    aptakube
    aptakubeDesktopItem
  ];
}
