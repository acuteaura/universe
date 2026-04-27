{pkgs, ...}: {
  home.packages = with pkgs; [
    ardour
    audacity
    blender
    cardinal
    graphite
    godot-mono
    inkscape
    krita
    lmms
    reaper
    vital
  ];
}
