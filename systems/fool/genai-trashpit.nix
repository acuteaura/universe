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

    koboldcpp = {
      enable = true;
      dataDir = "/media/gai/koboldcpp";
      useTailscaleSidecar = true;
      portMappings = [];
      extraArgs = "--host 0.0.0.0 " +
        "--sdmodel /workspace/z_image_turbo-Q4_0.gguf " +
        "--sdclip1 /workspace/Qwen3-4B-Instruct-2507-Q4_K_S.gguf " +
        "--sdvae /workspace/ae.safetensors " + 
        "--model /workspace/Snowpiercer-15B-v3c-Q6_K.gguf " + 
        "--embeddingsmodel /workspace/bge-m3-q8_0.gguf " +
        "--ttsmodel /workspace/Kokoro_no_espeak_Q4.gguf " +
        "--whispermodel /workspace/whisper-base.en-q5_1.bin "; 
        #"--mmproj /workspace/Ministral-3-3B-Instruct-2512-mmproj-Q8_0.gguf";
    };

    tailscale-sidecar = {
      enable = true;
      authKeyFile = "/etc/tailscale-keys/fool-gai";
      hostname = "fool-gai";
    };
  };
}
