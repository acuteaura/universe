{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./sunshine
  ];
  environment.systemPackages = with pkgs; [
    gamemode
    gamescope
    lutris
    mangohud
    protonup-qt
    protontricks
    winetricks
    wineWowPackages.stable

    unigine-superposition
    unigine-valley
  ];
  hardware.xpadneo.enable = lib.mkDefault false;
  services.sunshine-with-virtdisplay.enable = lib.mkDefault false;

  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = {};
      extraLibraries = pkgs:
        with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
          gamescope
        ];
    };
  };
}
