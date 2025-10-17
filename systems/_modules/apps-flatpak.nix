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
      (flathubApp "com.github.johnfactotum.Foliate")
      (flathubApp "com.github.marhkb.Pods")
      (flathubApp "com.github.mtkennerly.ludusavi")
      (flathubApp "com.github.wwmm.easyeffects")
      (flathubApp "com.moonlight_stream.Moonlight")
      (flathubApp "com.seafile.Client")
      (flathubApp "com.usebottles.bottles")
      (flathubApp "dev.vencord.Vesktop")
      (flathubApp "fr.handbrake.ghb")
      (flathubApp "im.riot.Riot")
      (flathubApp "io.github.martchus.syncthingtray")
      (flathubApp "io.kinvolk.Headlamp")
      (flathubApp "io.lmms.LMMS")
      (flathubApp "io.podman_desktop.PodmanDesktop")
      (flathubApp "it.mijorus.gearlever")
      (flathubApp "md.obsidian.Obsidian")
      (flathubApp "org.ardour.Ardour")
      (flathubApp "org.blender.Blender")
      (flathubApp "org.fooyin.fooyin")
      (flathubApp "org.inkscape.Inkscape")
      (flathubApp "org.kde.haruna")
      (flathubApp "org.kde.kasts")
      (flathubApp "org.kde.kdenlive")
      (flathubApp "org.kde.krita")
      (flathubApp "org.libreoffice.LibreOffice")
      (flathubApp "org.pgadmin.pgadmin4")
      (flathubApp "org.raspberrypi.rpi-imager")
      (flathubApp "org.signal.Signal")
      (flathubApp "org.sqlitebrowser.sqlitebrowser")
      (flathubApp "org.videolan.VLC")
      (flathubApp "rest.insomnia.Insomnia")
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
