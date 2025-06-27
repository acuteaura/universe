{
  pkgs,
  unstable,
  ...
}: {
  environment.systemPackages = with pkgs; [
    ardour
    blender
    brave
    cool-retro-term
    discord
    easyeffects
    element-desktop
    f2fs-tools
    firefox
    foliate
    fooyin
    ghostty
    gparted
    haruna
    inkscape
    insomnia
    kdePackages.kdenlive
    krita
    librewolf
    ludusavi
    maestral
    maestral-gui
    moonlight-qt
    obs-studio
    obsidian
    ocs-url
    remmina
    rpi-imager

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

    gearlever

    (pkgs.callPackage ../../packages/aptakube.nix {})
    (pkgs.callPackage ../../packages/headlamp.nix {})

    # check these for build failures on 25.11
    #archivebox
    #pgadmin4-desktopmode
    #lmms
    #seafile-client
    #handbrake
  ];

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [thunar-archive-plugin thunar-dropbox-plugin thunar-volman];
  };

  services.flatpak.packages = [
    "app.zen_browser.zen"
  ];
}
