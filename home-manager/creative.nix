{pkgs, ...}: {
  home.packages = with pkgs; [
    affinity.v3
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
