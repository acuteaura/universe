{pkgs, ...}: {
  imports = [
    ./flatpak.nix
  ];

  home.packages = with pkgs; [
    lmms
    typst
    vital
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
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

    (fooyin.overrideAttrs
      (old: {
        version = "0.9.2-3791e37";
        src = pkgs.fetchFromGitHub {
          owner = "fooyin";
          repo = "fooyin";
          rev = "3791e370230281df069c23fd3b3cfafd6d5f1a8b";
          sha256 = "sha256-+1Ao45BM9cIOhoGQthkHj/CfcGjKGcqNqLSWIBjMmTQ=";
        };
        patches = [];
        postPatch = "";
      }))
    ytmdesktop

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

  home.sessionVariables = {
    CLAUDE_CODE_EXECUTABLE = "${pkgs.claude-code-wrapped-claude}/bin/claude-code";
  };
}
