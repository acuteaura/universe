{pkgs, ...}: {
  imports = [
    ./creative.nix
    ./flatpak.nix
  ];

  home.packages = with pkgs; [
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })

    btop
    cryptsetup
    curl
    dig
    easyeffects
    ffmpeg
    file
    fish
    foliate
    ghostty
    git
    gnugrep
    gnumake
    gnupg
    gnused
    gparted
    #handbrake
    haruna
    htop
    junction
    #kdePackages.kdenlive
    llvm
    lmstudio
    moonlight-qt
    ocs-url
    openssl
    python3
    python3Packages.pip
    python3Packages.virtualenv
    scrcpy
    seafile-client
    seadrive-gui
    sshfs
    usbutils
    via
    vlc
    vscode
    wget
    (ytmdesktop.override {commandLineArgs = "--password-store=gnome-libsecret";})
    zed-editor

    (fooyin.overrideAttrs (old: {
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

    (wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        obs-vaapi
        obs-vkcapture
        obs-gstreamer
        obs-pipewire-audio-capture
      ];
    })

    # tools that are usually available on system when using HM standlone
  ];
}
