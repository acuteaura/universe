{
  pkgs,
  unstable,
  ...
}: {
  imports = [
    ./apps-flatpak.nix
  ];
  environment.systemPackages = with pkgs; [
    brave
    f2fs-tools
    firefox
    gparted
    librewolf
    ludusavi
    maestral
    maestral-gui
    ocs-url
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

    # check these for build failures on 25.11
    archivebox
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
