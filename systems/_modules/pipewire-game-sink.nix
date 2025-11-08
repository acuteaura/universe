{
  pkgs,
  lib,
  config,
  ...
}: {
  options.universe.pipewire-game-sink = {
    enable = lib.mkEnableOption "Enable virtual PipeWire sink for game audio recording";
  };

  config = lib.mkIf config.universe.pipewire-game-sink.enable {
    # Create a virtual PipeWire sink for game audio with automatic loopback to default sink

    # Prevent GameAudioSink from being selected as default
    services.pipewire.wireplumber.extraConfig."51-game-sink-no-default" = {
      "monitor.alsa.rules" = [];
      "node.rules" = [
        {
          matches = [
            {
              "node.name" = "GameAudioSink";
            }
          ];
          actions = {
            update-props = {
              "node.passive" = true;
              "session.suspend-timeout-seconds" = 0;
            };
          };
        }
      ];
    };
  };
}
