{pkgs, ...}: let
  changeResScript = pkgs.writeScript "set-res.fish" ''
    #!${pkgs.fish}/bin/fish
    argparse 'w/width=' 'h/height=' 'f/fps=' -- $argv; or exit 1
    set final_w 1920
    set final_h 1080
    set final_f 60
    if [ $_flag_w = "1920" ] && [ $_flag_h = "1200" ]
      set final_w 1920
      set final_h 1200
    end
    if [ $_flag_w = "2560" ] && [ $_flag_h = "1600" ]
      set final_w 1920
      set final_h 1200
    end
    if [ $_flag_f = "120" ] || [ $_flag_f = "144" ] || [ $_flag_f = "240" ]
      set final_f 120
    end
    ${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-2.mode.{$final_w}x{$final_h}@{$final_f}
  '';
  steamCmd = pkgs.writeScript ''launch-steam.fish'' ''
    #!${pkgs.fish}/bin/fish
    setsid steam steam://bigpicture > /tmp/steam-launch.stdout 2> /tmp/steam-launch.stderr
  '';
  prepRes = [
    {
      do = "${changeResScript} -w \$SUNSHINE_CLIENT_WIDTH -h $SUNSHINE_CLIENT_HEIGHT -f $SUNSHINE_CLIENT_FPS";
      undo = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-2.mode.5120x1440@240";
    }
  ];
  # Helper utility for launching Steam games from Sunshine. This works around
  # issue where Sunshine's security wrapper prevents Steam from launching.
  # Examples:
  #   steam-run-url steam://rungameid/1086940  # Start Baldur's Gate 3
  #   steam-run-url steam://open/bigpicture    # Start Steam in Big Picture mode
  steam-run-url = pkgs.writeShellApplication {
    name = "steam-run-url";
    text = ''
      echo "$1" > "/run/user/$(id --user)/steam-run-url.fifo"
    '';
    runtimeInputs = [
      pkgs.coreutils # For `id` command
    ];
  };
in {
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    applications.apps = [
      {
        name = "Desktop";
        prep-cmd = prepRes;
        auto-detach = "true";
      }
      {
        name = "Steam";
        prep-cmd = prepRes;
        auto-detach = "true";
        cmd = "${steam-run-url}/bin/steam-run-url steam://open/gamepadui";
        image-path = "steam.png";
      }
    ];
  };

  systemd.user.services.steam-run-url-service = {
    enable = true;
    description = "Listen and starts steam games by id";
    wantedBy = ["default.target"];
    partOf = ["default.target"];
    wants = ["default.target"];
    after = ["default.target"];
    serviceConfig.Restart = "on-failure";
    script = toString (pkgs.writers.writePython3 "steam-run-url-service" {} ''
      import os
      from pathlib import Path
      import subprocess

      pipe_path = Path(f'/run/user/{os.getuid()}/steam-run-url.fifo')
      try:
          pipe_path.parent.mkdir(parents=True, exist_ok=True)
          pipe_path.unlink(missing_ok=True)
          os.mkfifo(pipe_path, 0o600)
          while True:
              with pipe_path.open(encoding='utf-8') as pipe:
                  subprocess.Popen(['steam', pipe.read().strip()])
      finally:
          pipe_path.unlink(missing_ok=True)
    '');
    path = [
      pkgs.gamemode
      pkgs.steam
    ];
  };

  environment.systemPackages = [steam-run-url];
}
