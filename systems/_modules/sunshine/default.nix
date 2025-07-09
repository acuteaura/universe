{
  pkgs,
  lib,
  config,
  ...
}: let
  kScreenDoctor = "${lib.getExe' pkgs.kdePackages.libkscreen "kscreen-doctor"}";
  phyMode = "5120x1440@240";
  phyScreen = "DP-2";
  # https://www.amazon.de/dp/B0F2M4CPX4
  # or if you're copying this you can fuck around with forcing an EDID and find out
  # but I'd prefer not to
  virtScreen = "HDMI-A-1";
  setVirtScript = pkgs.writeScript "set-virt-out.fish" ''
    #!${pkgs.fish}/bin/fish
    set -x QT_QPA_PLATFORM wayland-egl
    set logfile "/tmp/set-virt-out.log"
    echo "started set-virt-out (date)" >> $logfile
    argparse "s/scale=?" "w/width=?" "h/height=?" "f/fps=?" -- $argv
    set final_w (set -q _flag_w && echo $_flag_w || echo "$SUNSHINE_CLIENT_WIDTH")
    set final_h (set -q _flag_h && echo $_flag_h || echo "$SUNSHINE_CLIENT_HEIGHT")
    set final_f (set -q _flag_f && echo $_flag_f || echo "$SUNSHINE_CLIENT_FPS")
    set final_s (set -q _flag_s && echo $_flag_s || echo "1")

    # MBP workaround
    if [ "$final_w" = "3024" ] && [ "$final_h" = "1890" ]
      echo "mbp workaround applied" >> $logfile
      set final_w 2560
      set final_h 1600
      set final_f 60
    end

    # framerate unsupported
    if [ ! "$final_f" = "120" ] && [ ! "$final_f" = "60" ]
      set final_f 120
    end

    echo "final res: "{$final_w}x{$final_h}@{$final_f} >> $logfile

    ${kScreenDoctor} output.${phyScreen}.disable output.${virtScreen}.enable output.${virtScreen}.mode.{$final_w}x{$final_h}@{$final_f} output.${virtScreen}.scale.{$final_s} >> $logfile 2>> $logfile
  '';
  setPhyScript = pkgs.writeScript "set-screen-phy.fish" ''
    #!${pkgs.fish}/bin/fish
    set -x QT_QPA_PLATFORM wayland
    ${kScreenDoctor} output.${virtScreen}.disable output.${phyScreen}.enable output.${phyScreen}.mode.${phyMode}
  '';
  screenScriptsPkg = pkgs.runCommand "set-screen-commands" {inherit setPhyScript setVirtScript;} ''
    mkdir -p $out/bin
    ln -s $setPhyScript $out/bin/set-phy-out
    ln -s $setVirtScript $out/bin/set-virt-out
  '';

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
  options.services.sunshine-with-virtdisplay = {
    enable = lib.mkEnableOption "sunshine with virtual display switching";
  };

  config = lib.mkIf config.services.sunshine-with-virtdisplay.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      applications.apps = import ./apps.nix {inherit pkgs setPhyScript setVirtScript steam-run-url;};
      settings = {
        min_log_level = "info";
      };
    };

    boot.kernelParams = [
      "video=HDMI-A-1:1920x1080@60"
      "video=HDMI-A-1:1920x1080@120"
      "video=HDMI-A-1:2560x1440@60"
      "video=HDMI-A-1:2560x1440@120"
      "video=HDMI-A-1:2560x1600@60"
      "video=HDMI-A-1:2560x1600@120"
      "video=HDMI-A-1:2880x1920@60"
      "video=HDMI-A-1:2880x1920@120"
    ];

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
            steam_env = os.environ.copy()
            steam_env["QT_QPA_PLATFORM"] = "wayland"
            while True:
                with pipe_path.open(encoding='utf-8') as pipe:
                    subprocess.Popen(['steam', pipe.read().strip()], env=steam_env)
        finally:
            pipe_path.unlink(missing_ok=True)
      '');
      path = [
        pkgs.gamemode
        pkgs.steam
      ];
    };

    environment.systemPackages = [steam-run-url screenScriptsPkg];
  };
}
