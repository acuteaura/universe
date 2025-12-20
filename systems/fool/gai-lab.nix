{
  pkgs,
  constants,
  ...
}: let
  # Import koboldcpp configs
  koboldcppConfigs = import ./koboldcpp-configs.nix {inherit pkgs;};
in {
  environment.systemPackages = with pkgs; [
    ollama
  ];

  environment.sessionVariables.OLLAMA_HOST = "fool-gai.atlas-ide.ts.net:11434";

  universe.serviceContainers = {
    comfyui = {
      enable = true;
      autoStart = true;
      dataDir = "/media/gai/comfyui";
    };

    invokeai = {
      enable = true;
      autoStart = false;
      dataDir = "/media/gai/invoke";
      image = "ghcr.io/invoke-ai/invokeai:main-rocm";
      extraVolumes = ["/media/tensors:/media/tensors"];
    };

    koboldcpp = {
      enable = true;
      dataDir = "/media/gai/koboldcpp";
      autoStart = true;
      image = "docker.io/koboldai/koboldcpp:latest";

      extraArgs = {
        admin = ""; # Enable admin mode
        admindir = "/configs"; # Directory containing .kcpps config files
        host = "0.0.0.0";
        port = "5001";

        config = "/configs/Snowpiercer-15B-v4-Q6_K_L.kcpps"; # Directory for other config files
      };

      # Mount the configs directory into the container as read-only
      extraVolumes = [
        "${koboldcppConfigs.configsDir}:/configs:ro"
      ];
    };

    sillytavern = {
      enable = true;
      autoStart = true;
      dataDir = "/media/gai/sillytavern";
    };
  };
}
