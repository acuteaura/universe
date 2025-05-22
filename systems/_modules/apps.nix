{
  pkgs,
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
    f2fs-tools
    firefox
    foliate
    ghostty
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
    librewolf
    lmms
    lmstudio
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
    virt-manager
    virt-viewer
    vlc
    vscode
    wezterm
    wl-clipboard-rs
    zed-editor

    rpi-imager
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
