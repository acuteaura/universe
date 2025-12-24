{pkgs}: let
  # KoboldCpp .kcpps config files for admin mode model switching
  # Imports generated model maps from koboldcpp-models.nix
  # Helper function to generate .kcpps config files
  makeKcppsConfig = name: args:
    pkgs.writeTextFile {
      name = "${name}.kcpps";
      text = builtins.toJSON args;
    };

  baseSettings = {
    # GPU configuration
    gpulayers = 999; # inject that shit straight into my VRAM
    usevulkan = null;
    flashattention = null;

    # Context and performance
    contextsize = 8192;
  };

  # Import the generated model maps
  models = import ./koboldcpp-models.nix;

  commonModels = {
    embeddingsmodel = "/workspace/embeddings/${models.embeddings.bge_m3_q8_0}";
    ttsmodel = "/workspace/tts/${models.tts.Kokoro_no_espeak_Q4}";
    whispermodel = "/workspace/whisper/${models.whisper.whisper_base_en_q5_1}";
  };

  zImageSettings = {
    sdmodel = "/workspace/image/${models.image.z_image_turbo_Q4_0}";
    sdclip1 = "/workspace/clip/${models.clip.Qwen3_4B_Instruct_2507_Q4_K_S}";
    sdvae = "/workspace/image/${models.image.ae}";
  };

  # Generate a config for each main model
  # Convert attribute set to list of {name, filename} pairs
  mainModelsList = builtins.map (name: {
    inherit name;
    filename = models.main.${name};
  }) (builtins.attrNames models.main);

  allConfigs =
    map (
      model:
        makeKcppsConfig model.name (baseSettings
          // commonModels
          // zImageSettings
          // {
            model = "/workspace/main/${model.filename}";
          })
    )
    mainModelsList;

  # Create a single directory with all config files
  # This will be installed to /run/current-system and can be referenced statically
  configsDir = pkgs.runCommand "koboldcpp-configs" {} ''
    mkdir -p $out/share/koboldcpp/configs
    ${builtins.concatStringsSep "\n" (map (cfg: "cp ${cfg} $out/share/koboldcpp/configs/${cfg.name}") allConfigs)}
  '';
in {
  # Export the configs directory for use in system configuration
  inherit configsDir;
}
