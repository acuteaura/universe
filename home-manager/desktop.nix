{
  pkgs,
  unstable,
  ...
}: {
  home.packages = with pkgs; [
    mesa
    aptakube
    (wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        obs-vaapi
        obs-vkcapture
        obs-gstreamer
        obs-pipewire-audio-capture
      ];
    })
  ];

  home.file.".config/kwalletrc".text = ''
    [Wallet]
    Enabled=false
  '';
}
