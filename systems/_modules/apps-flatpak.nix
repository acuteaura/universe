_: let
  flathubApp = appId: {
    inherit appId;
    origin = "flathub";
  };
in {
  services.flatpak = {
    update = {
      onActivation = true;
      auto.enable = false;
    };

    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [
      (flathubApp "com.github.mtkennerly.ludusavi")
      (flathubApp "com.usebottles.bottles")
      (flathubApp "dev.vencord.Vesktop")
      (flathubApp "fr.handbrake.ghb")
      (flathubApp "im.riot.Riot")
      (flathubApp "io.kinvolk.Headlamp")
      (flathubApp "io.lmms.LMMS")
      (flathubApp "io.podman_desktop.PodmanDesktop")
      (flathubApp "it.mijorus.gearlever")
      (flathubApp "md.obsidian.Obsidian")
      (flathubApp "org.libreoffice.LibreOffice")
      (flathubApp "org.pgadmin.pgadmin4")
      (flathubApp "org.raspberrypi.rpi-imager")
      (flathubApp "org.signal.Signal")
      (flathubApp "org.sqlitebrowser.sqlitebrowser")
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

    # element is a smartass
    overrides."im.riot.Riot" = {
      Context = {
        sockets = [
          "session-bus"
        ];
        filesystems = [
          "xdg-download"
        ];
      };

      Environment = {
        XDG_CURRENT_DESKTOP = "GNOME";
        DESKTOP_SESSION = "gnome";
        # Unset KDE variables
        KDE_FULL_SESSION = "";
        KDE_SESSION_VERSION = "";
      };

      "Session Bus Policy" = {
        "org.freedesktop.secrets" = "talk";
      };
    };
  };
}
