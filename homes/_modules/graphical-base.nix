# Only use this set of packages on NixOS with a matching branch!
# Mesa has become very reliant on matching versions...
{
  config,
  pkgs,
  unstable,
  ...
}: {
  home.packages = with pkgs; [
    appimage-run
    brave
    easyeffects
    firefox
    haruna
    inkscape
    insomnia
    kdePackages.koko
    kdePackages.krecorder
    obsidian
    signal-desktop
    sqlitebrowser
    strawberry
    syncthingtray
    thunderbird
    chromium
    virt-manager
    virt-viewer
    vlc
    vscode
    wezterm
    unstable.zed-editor
  ];
}
