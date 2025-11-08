{pkgs, ...}: let
  # Script that runs as root via systemd service
  setGPUPerfService = pkgs.writeScript "set-gpu-perf-service" ''
    #!/bin/sh
    LEVEL="$1"
    if [ -z "$LEVEL" ] || ! echo "$LEVEL" | grep -qE '^(auto|low|high)$'; then
      echo "Invalid level: $LEVEL" >&2
      exit 1
    fi
    echo "$LEVEL" > /sys/class/drm/card1/device/power_dpm_force_performance_level
    echo "GPU performance level set to: $LEVEL"
  '';

  # User-facing script to get GPU performance (no root needed)
  getGPUPerf = pkgs.writeShellApplication {
    name = "get-gpu-performance";
    runtimeInputs = [];
    text = ''
      cat /sys/class/drm/card1/device/power_dpm_force_performance_level
    '';
  };

  # User-facing script to set GPU performance
  setGPUPerf = pkgs.writeShellApplication {
    name = "set-gpu-performance";
    runtimeInputs = [pkgs.libnotify pkgs.systemd];
    text = ''
      if [ "$#" -ne 1 ]; then
        echo "Usage: set-gpu-performance <auto|low|high>"
        exit 1
      fi

      systemctl start "gpu-performance@$1.service"

      if [ -n "''${WAYLAND_DISPLAY:-}" ] || [ -n "''${DISPLAY:-}" ]; then
        notify-send "Set GPU Performance Profile" "Level: $1"
      fi
    '';
  };

  # Gaming wrapper script - works with Steam's no_new_privs
  gottaGoFast = pkgs.writeShellApplication {
    name = "gottagofast";
    runtimeInputs = [pkgs.libnotify pkgs.power-profiles-daemon pkgs.coreutils pkgs.systemd pkgs.pipewire];
    text = ''
      if [ "$#" -eq 0 ]; then
        echo "Usage: gottagofast <command> [args...]"
        exit 1
      fi

      # Save current settings (allow failures)
      saved_gpu=$(cat /sys/class/drm/card1/device/power_dpm_force_performance_level 2>/dev/null || echo "auto")
      saved_epp=$(powerprofilesctl get 2>/dev/null || echo "balanced")

      # Cleanup function to restore settings
      # shellcheck disable=SC2329
      cleanup() {
        # Restore GPU using systemd service (works with no_new_privs)
        systemctl start "gpu-performance@$saved_gpu.service"

        # Restore CPU profile (ignore failures)
        powerprofilesctl set "$saved_epp"

        # Try to send notification (ignore failures)
        if [ -n "''${WAYLAND_DISPLAY:-}" ] || [ -n "''${DISPLAY:-}" ]; then
          case "$saved_gpu" in
            high) icon="speedometer" ;;
            low) icon="battery-profile-powersave" ;;
            auto) icon="speedometer-medium" ;;
            *) icon="dialog-information" ;;
          esac
          notify-send --icon="$icon" "GOTTAGOFAST" "Restored:\nGPU: $saved_gpu\nCPU: $saved_epp" 2>/dev/null || true
        fi
      }

      # Trap EXIT, SIGINT, SIGTERM to ensure cleanup
      trap cleanup EXIT INT TERM

      # Set performance mode using systemd service (works with no_new_privs)
      systemctl start gpu-performance@high.service
      powerprofilesctl set performance

      # Send notification (ignore failures)
      if [ -n "''${WAYLAND_DISPLAY:-}" ] || [ -n "''${WAYLAND_DISPLAY:-}" ]; then
        notify-send --icon=speedometer "GOTTAGOFAST" "GPU: high\nCPU: performance" 2>/dev/null || true
      fi

      # Force game audio to use the Game Audio sink
      # PULSE_SINK is used by Wine/Proton via PipeWire's PulseAudio compatibility layer
      # PIPEWIRE_NODE is used by native PipeWire/ALSA clients
      export PULSE_SINK="GameAudioSink"
      export PIPEWIRE_NODE="GameAudioSink"
      export PIPEWIRE_LATENCY="512/48000"

      # Run the command - this is the critical part that must execute
      "$@"

      exit_code=$?
      exit $exit_code
    '';
  };
in {
  services.xserver.videoDrivers = ["amdgpu"];

  # Systemd service template for setting GPU performance
  # Can be called without sudo, works with no_new_privs
  systemd.services."gpu-performance@" = {
    description = "Set GPU Performance Level to %i";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${setGPUPerfService} %i";
      RemainAfterExit = false;
    };
  };

  # Polkit rule to allow users in wheel group to start the service without password
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          action.lookup("unit").indexOf("gpu-performance@") == 0 &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  environment.systemPackages = [
    getGPUPerf
    setGPUPerf
    gottaGoFast
  ];

  boot.kernelParams = ["amdgpu.ppfeaturemask=0xffffffff" "amdgpu.dcdebugmask=0x12"];
}
