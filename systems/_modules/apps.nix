{
  pkgs,
  lib,
  config,
  ...
}: {
  options.universe.apps = {
    enable = lib.mkEnableOption "Enable default native desktop applications";
  };

  config = lib.mkIf config.universe.apps.enable {
    environment.systemPackages = with pkgs; [
      ardour
      audacity
      blender
      easyeffects
      foliate
      ghostty
      gparted
      handbrake
      haruna
      inkscape
      kdePackages.kdenlive
      krita
      lmstudio
      moonlight-qt
      ocs-url
      scrcpy
      via
      vlc
      vscode
      zed-editor

      (wrapOBS {
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
      binfmt = false;
    };

    programs.thunar = {
      enable = false;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-dropbox-plugin
        thunar-volman
      ];
    };
  };
}
