{
  pkgs,
  unstable,
  ...
}: {
  environment.systemPackages = with pkgs; [
    brave
    firefox
    gparted
    insync
    librewolf
    ludusavi
    maestral
    maestral-gui
    ocs-url
    scrcpy
    via
    virt-manager
    vscode
    unstable.zed-editor

    aptakube
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        obs-vaapi
        obs-vkcapture
        obs-gstreamer
        obs-pipewire-audio-capture
      ];
    })
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
}
