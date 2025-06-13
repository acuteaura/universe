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
    f2fs-tools
    firefox
    foliate
    fooyin
    ghostty
    gparted
    handbrake
    haruna
    inkscape
    insomnia
    kdePackages.kdenlive
    krita
    librewolf
    lmms
    ludusavi
    maestral
    maestral-gui
    moonlight-qt
    obs-studio
    obsidian
    ocs-url
    pgadmin4-desktopmode
    remmina
    rpi-imager
    seafile-client
    signal-desktop
    sqlitebrowser
    syncthingtray
    thunderbird
    via
    virt-manager
    virt-viewer
    vlc
    vscode
    wezterm
    unstable.zed-editor
  ];

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  services.flatpak.packages = [
    "app.zen_browser.zen"
  ];
}
