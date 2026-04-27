{pkgs, ...}: {
  imports = [
    ./creative.nix
    ./flatpak.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })

    cryptsetup
    curl
    dig
    easyeffects
    fedistar
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
    htop
    llvm
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
    spotify
    usbutils
    via
    vlc
    vscode
    wget
    #(ytmdesktop.override {commandLineArgs = "--password-store=gnome-libsecret";})

    fooyin

    # (wrapOBS {
    #   plugins = with pkgs.obs-studio-plugins; [
    #     obs-vaapi
    #     obs-vkcapture
    #     obs-gstreamer
    #     obs-pipewire-audio-capture
    #   ];
    # })
  ];
}
