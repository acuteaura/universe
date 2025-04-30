{pkgs, ...}: let
  phyMode = "5120x1440@240";
  phyScreen = "DP-2";
  virtScreen = "HDMI-A-1";
  setVirtScript = pkgs.writeScript "set-screen-virt.fish" ''
    #!${pkgs.fish}/bin/fish
    set final_w 1920
    set final_h 1080
    set final_f 60
    set final_s 1
    echo "hello from script" > /tmp/resswitch.log
    if [ "1920" = "$SUNSHINE_CLIENT_WIDTH" ] && [ "1200" = "$SUNSHINE_CLIENT_HEIGHT" ]
      set final_w 1920
      set final_h 1200
    end
    if [ "2560" = "$SUNSHINE_CLIENT_WIDTH" ] && [ "1600" = "$SUNSHINE_CLIENT_HEIGHT" ]
      echo "hit 2560x1600!" >> /tmp/resswitch.log
      set final_w 2560
      set final_h 1600
      set final_s 2
    end
    if [ $SUNSHINE_CLIENT_FPS = "120" ] || [ $SUNSHINE_CLIENT_FPS = "144" ] || [ $SUNSHINE_CLIENT_FPS = "240" ]
      echo "hit 120 FPS" >> /tmp/resswitch.log
      set final_f 120
    end
    ${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.${phyScreen}.disable output.${virtScreen}.enable output.${virtScreen}.mode.{$final_w}x{$final_h}@{$final_f} output.${virtScreen}.scale.{$final_s}
  '';
  setPhyScript = pkgs.writeScript "set-screen-phy.fish" ''
    #!${pkgs.fish}/bin/fish
    set -x QT_QPA_PLATFORM wayland
    ${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.${virtScreen}.disable output.${phyScreen}.enable output.${phyScreen}.mode.${phyMode}
  '';
  setPhyScriptApp = pkgs.writeShellApplication {
    name = "set-phy-out";
    text = setPhyScript;
  };
  prepRes = [
    {
      do = "${setVirtScript}";
      undo = "${setPhyScript}";
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

  environment.systemPackages = [steam-run-url setPhyScriptApp];
}
