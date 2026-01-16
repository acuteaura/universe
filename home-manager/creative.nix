{pkgs, ...}: {
  home.packages = with pkgs; [
    affinity.v3
    ardour
    audacity
    blender
    inkscape
    krita
    lmms
    reaper
    vital
  ];
}
