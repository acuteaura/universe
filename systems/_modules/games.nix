{
  pkgs,
  lib,
  unstable,
  ...
}: {
  environment.systemPackages = with unstable; [
    gamemode
    gamescope
    lutris
    mangohud
    protonup-qt
    protontricks
    protonplus
    bottles
    
    unigine-superposition
    unigine-valley

    moonlight-qt
  ];
  hardware.xpadneo.enable = lib.mkDefault false;

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
