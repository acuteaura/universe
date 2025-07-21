{...}: let
  flathubApp = appId: {
    inherit appId;
    origin = "flathub";
  };
in {
  services.flatpak = {
    update.onActivation = true;
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [
      (flathubApp "org.ardour.Ardour")
      (flathubApp "org.blender.Blender")
      (flathubApp "com.discordapp.Discord")
      (flathubApp "com.github.johnfactotum.Foliate")
      (flathubApp "org.fooyin.fooyin")
      (flathubApp "org.kde.haruna")
      (flathubApp "org.inkscape.Inkscape")
      (flathubApp "rest.insomnia.Insomnia")
      (flathubApp "org.kde.krita")
      (flathubApp "org.kde.kdenlive")
      (flathubApp "com.github.mtkennerly.ludusavi")
      (flathubApp "com.moonlight_stream.Moonlight")
      (flathubApp "md.obsidian.Obsidian")
      (flathubApp "org.raspberrypi.rpi-imager")
      (flathubApp "org.signal.Signal")
      (flathubApp "org.sqlitebrowser.sqlitebrowser")
      (flathubApp "io.github.martchus.syncthingtray")
      (flathubApp "org.videolan.VLC")
      (flathubApp "io.podman_desktop.PodmanDesktop")
      (flathubApp "com.github.marhkb.Pods")
      (flathubApp "it.mijorus.gearlever")
      (flathubApp "io.kinvolk.Headlamp")
      (flathubApp "org.pgadmin.pgadmin4")
      (flathubApp "io.lmms.LMMS")
      (flathubApp "com.seafile.Client")
      (flathubApp "fr.handbrake.ghb")
      (flathubApp "org.kde.kasts")
      (flathubApp "com.github.wwmm.easyeffects")
      (flathubApp "im.riot.Riot")
    ];

    overrides.global = {
      Context.filesystems = [];
      Environment = {
        #GTK_THEME = "Fluent-dark-compact:dark";
      };
    };
    overrides."app.zen_browser.zen" = {
      Context.filesystems = [
        "/home/aurelia/.mozilla/native-messaging-hosts:ro"
      ];
      "Session Bus Policy" = {
        "org.freedesktop.Flatpak" = "talk";
      };
    };
  };
}
