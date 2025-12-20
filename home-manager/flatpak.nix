_: let
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
      (flathubApp "com.github.mtkennerly.ludusavi")
      (flathubApp "com.rafaelmardojai.Blanket")
      (flathubApp "com.usebottles.bottles")
      (flathubApp "fr.handbrake.ghb")
      (flathubApp "im.riot.Riot")
      (flathubApp "io.kinvolk.Headlamp")
      (flathubApp "io.podman_desktop.PodmanDesktop")
      (flathubApp "md.obsidian.Obsidian")
      (flathubApp "org.fooyin.fooyin")
      (flathubApp "org.pgadmin.pgadmin4")
      (flathubApp "org.raspberrypi.rpi-imager")
      (flathubApp "org.signal.Signal")
      (flathubApp "org.sqlitebrowser.sqlitebrowser")
      (flathubApp "rest.insomnia.Insomnia")
    ];

    overrides.global = {
      Context.filesystems = [
        "/home/aurelia/.themes:ro"
        "/home/aurelia/.icons:ro"
        "/home/aurelia/.themes:ro"
        "/home/aurelia/.local/share/themes"
        "/home/aurelia/.local/share/icons"
      ];
      Environment = {
        GTK_THEME = "Fluent-dark-compact:dark";
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
