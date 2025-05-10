{
  pkgs,
  unstable,
  ...
}: {
  environment.systemPackages = with pkgs; [
    appimage-run
    archivebox
    blender
    (pkgs.brave.override {
      vulkanSupport = true;
      commandLineArgs = "--enable-features=AcceleratedVideoDecodeLinuxGL,VaapiVideoDecoder,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE";
    })
    cool-retro-term
    discord
    easyeffects
    firefox
    foliate
    handbrake
    haruna
    inkscape
    insomnia
    kdePackages.kdenlive
    kdePackages.koko
    kdePackages.krecorder
    obsidian
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
    unstable.zed-editor
    virt-manager
    virt-viewer
    vlc
    vscode
    wezterm

    streamcontroller
    obs-studio

    ardour
    lmms
    krita
    ocs-url
  ];

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
}
