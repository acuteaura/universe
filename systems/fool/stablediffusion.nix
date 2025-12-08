{
  pkgs,
  constants,
  ...
}: {
  environment.systemPackages = with pkgs; [
    ollama
  ];

  environment.sessionVariables.OLLAMA_HOST = "fool-gai.atlas-ide.ts.net:11434";
  universe.comfyui-container = {
    enable = true;
    rdnaGeneration = "rdna3";
    useAPU = false;
    dataDir = "/media/comfyui";
    useTailscaleSidecar = true;
    portMappings = [];
  };

  universe.invokeai-container = {
    enable = true;
    rdnaGeneration = "rdna3";
    useAPU = false;
    dataDir = "/media/invoke";
    useTailscaleSidecar = true;
    portMappings = [];
    extraVolumes = ["/media/tensors:/media/tensors"];
  };

  universe.sillytavern-container = {
    enable = true;
    dataDir = "/media/sillytavern";
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

  universe.ollama-container = {
    enable = true;
    dataDir = "/media/ollama";
    useTailscaleSidecar = true;
    portMappings = [];
    useRocm = true;
    rdnaGeneration = "rdna3";
  };

  universe.tailscale-sidecar = {
    enable = true;
    authKeyFile = "/etc/tailscale-keys/fool-gai";
    hostname = "fool-gai";
  };
}
