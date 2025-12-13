{
  pkgs,
  constants,
  ...
}: {
  environment.systemPackages = with pkgs; [
    ollama
  ];

  environment.sessionVariables.OLLAMA_HOST = "fool-gai.atlas-ide.ts.net:11434";

  universe.gai = {
    comfyui = {
      enable = true;
      rdnaGeneration = "rdna3";
      useAPU = false;
      dataDir = "/media/gai/comfyui";
      useTailscaleSidecar = true;
      portMappings = [];
    };

    invokeai = {
      enable = true;
      rdnaGeneration = "rdna3";
      useAPU = false;
      dataDir = "/media/gai/invoke";
      useTailscaleSidecar = true;
      portMappings = [];
      extraVolumes = ["/media/tensors:/media/tensors"];
    };

    sillytavern = {
      enable = true;
      dataDir = "/media/gai/sillytavern";
      useTailscaleSidecar = true;
      portMappings = [];
      enablePlugins = true;
      enableExtensions = true;
      image = "ghcr.io/sillytavern/sillytavern:1.13.5";
      ssl = {
        enable = true;
        hostname = "fool.atlas-ide.ts.net";
      };
    };

    ollama = {
      enable = true;
      dataDir = "/media/gai/ollama";
      useTailscaleSidecar = true;
      portMappings = [];
    };

    tailscale-sidecar = {
      enable = true;
      authKeyFile = "/etc/tailscale-keys/fool-gai";
      hostname = "fool-gai";
    };
  };
}
