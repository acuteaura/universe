{
  pkgs,
  unstable,
  ...
}: {
  imports = [
    ../../apps/headlamp.nix
  ];

  environment.systemPackages = with pkgs; [
    appimage-run
    archivebox
    ardour
    blender
    brave
    cool-retro-term
    discord
    easyeffects
    firefox
    foliate
    gparted
    handbrake
    haruna
    inkscape
    insomnia
    insync
    kdePackages.kdenlive
    kdePackages.koko
    kdePackages.krecorder
    krita
    lmms
    maestral
    maestral-gui
    obs-studio
    obsidian
    ocs-url
    pgadmin4-desktopmode
    qmk
    remmina
    seafile-client
    shotwell
    signal-desktop
    sqlitebrowser
    strawberry
    syncthingtray
    thunderbird
    unstable.zed-editor
    virt-manager
    virt-viewer
    vlc
    vscode
    wezterm
    wl-clipboard-rs
    ghostty
  ];

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };
}
