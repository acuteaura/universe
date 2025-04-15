# Only use this set of packages on NixOS with a matching branch!
# Mesa has become very reliant on matching versions...
{pkgs, ...}: {
  home.packages = with pkgs; [
    archivebox
    blender
    cool-retro-term
    discord
    foliate
    handbrake
    kdePackages.kdenlive
    qmk
    seafile-client
    shotwell
    simh
    ventoy-full
  ];
}
