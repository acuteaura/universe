{pkgs, ...}: {
  home.packages = with pkgs; [
    ardour
    audacity
    blender
    cardinal
    godot-mono
    inkscape
    krita
    lmms
    reaper
    vital
  ];
}
