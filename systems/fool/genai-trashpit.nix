{
  pkgs,
  constants,
  ...
}: let
  koboldModels = {
    sdmodel = "z_image_turbo-Q4_0.gguf";
    sdclip1 = "Qwen3-4B-Instruct-2507-Q4_K_S.gguf";
    sdvae = "ae.safetensors";
    model = "gemma-3-27b-it-abliterated.q3_k_m.gguf";
    embeddingsmodel = "bge-m3-q8_0.gguf";
    ttsmodel = "Kokoro_no_espeak_Q4.gguf";
    whispermodel = "whisper-base.en-q5_1.bin";
    #mmproj = "Ministral-3-3B-Instruct-2512-mmproj-Q8_0.gguf";
  };
in {
  environment.systemPackages = with pkgs; [
    ollama
  ];

  environment.sessionVariables.OLLAMA_HOST = "fool-gai.atlas-ide.ts.net:11434";

  universe.gai = {
    comfyui = {
      enable = false;
      dataDir = "/media/gai/comfyui";
    };

    invokeai = {
      enable = true;
      dataDir = "/media/gai/invoke";
      extraVolumes = ["/media/tensors:/media/tensors"];
    };

    koboldcpp = {
      enable = true;
      dataDir = "/media/gai/koboldcpp";
      extraArgs =
        "--host ${constants.tailscale.ip.fool} "
        + "--sdmodel /workspace/${koboldModels.sdmodel} "
        + "--sdclip1 /workspace/${koboldModels.sdclip1} "
        + "--sdvae /workspace/${koboldModels.sdvae} "
        + "--model /workspace/${koboldModels.model} "
        + "--embeddingsmodel /workspace/${koboldModels.embeddingsmodel} "
        + "--ttsmodel /workspace/${koboldModels.ttsmodel} "
        + "--whispermodel /workspace/${koboldModels.whispermodel} "
        + "--gpulayers 150";
      #"--mmproj /workspace/${koboldModels.mmproj}";
    };

    sillytavern = {
      enable = true;
      dataDir = "/media/gai/sillytavern";
    };
  };
}
