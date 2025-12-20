{pkgs, ...}: {
  imports = [
    ./flatpak.nix
  ];

  home.packages = with pkgs; [
    lmms
    typst
    vital
    vesktop
    junction
    seafile-client

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

    # tools that are usually available on system when using HM standlone
    python3
    python3Packages.pip
    python3Packages.virtualenv
  ];

  home.file.".config/kwalletrc".text = ''
    [Wallet]
    Enabled=false
  '';
}
