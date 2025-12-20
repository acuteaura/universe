{pkgs}: let
  # KoboldCpp .kcpps config files for admin mode model switching
  # These configs can be loaded dynamically via the admin interface
  # Helper function to generate .kcpps config files
  # .kcpps files are JSON configs that koboldcpp can load
  makeKcppsConfig = name: args:
    pkgs.writeTextFile {
      name = "koboldcpp-${name}.kcpps";
      text = builtins.toJSON args;
    };

  baseSettings = {
    # GPU configuration
    gpulayers = 60;
    usevulkan = null;

    flashattention = null;

    # Context and performance
    contextsize = 8192;
  };

  commonModels = {
    embeddingsmodel = "/workspace/bge-m3-q8_0.gguf";
    ttsmodel = "/workspace/Kokoro_no_espeak_Q4.gguf";
    whispermodel = "/workspace/whisper-base.en-q5_1.bin";
  };

  # Default configuration matching current setup
  defaultConfig = valkyrie2Config;

  magidoniaConfig = makeKcppsConfig "default" (baseSettings
    // commonModels
    // {
      model = "/workspace/TheDrummer_Magidonia-24B-v4.3-Q6_K_L.gguf";
    });

  snowpiercer4Config = makeKcppsConfig "snowpiercer" (baseSettings
    // commonModels
    // {
      # Model paths (relative to workspace/dataDir)
      model = "/workspace/TheDrummer_Snowpiercer-15B-v4-Q6_K_L.gguf";
    });

  gptOssConfig = makeKcppsConfig "gpt-oss" (baseSettings
    // commonModels
    // {
      model = "/workspace/gpt-oss-20b-Derestricted.Q4_K_S.gguf";
    });

  cydoniaConfig = makeKcppsConfig "cydonia" (baseSettings
    // commonModels
    // {
      model = "/workspace/Cydonia-24B-v4zk-Q4_K_M.gguf";
    });

  gemma3Config = makeKcppsConfig "gemma3" (baseSettings
    // commonModels
    // {
      model = "/workspace/gemma-3-27b-it-abliterated.q3_k_m.gguf";
    });

  valkyrie1Config = makeKcppsConfig "valkyrie" (baseSettings
    // commonModels
    // {
      model = "/workspace/TheDrummer_Valkyrie-49B-v1-IQ4_XS.gguf";
    });

  valkyrie2Config = makeKcppsConfig "valkyrie2" (baseSettings
    // commonModels
    // {
      model = "/workspace/TheDrummer_Valkyrie-49B-v1-IQ3_M.gguf";
    });

  # Create a directory with all configs
  configsDir = pkgs.runCommand "koboldcpp-configs" {} ''
    mkdir -p $out
    cp ${defaultConfig} $out/default.kcpps
    cp ${magidoniaConfig} $out/Magidonia-24B-v4.3-Q6_K_L.kcpps
    cp ${snowpiercer4Config} $out/Snowpiercer-15B-v4-Q6_K_L.kcpps
    cp ${gptOssConfig} $out/gpt-oss-20b-Derestricted.Q4_K_S.kcpps
    cp ${cydoniaConfig} $out/Cydonia-24B-v4zk-Q4_K_M.kcpps
    cp ${gemma3Config} $out/gemma-3-27b-it-abliterated.q3_k_m.kcpps
    cp ${valkyrie1Config} $out/TheDrummer_Valkyrie-49B-v1-IQ4_XSL.kcpps
    cp ${valkyrie2Config} $out/TheDrummer_Valkyrie-49B-v1-IQ3_M.kcpps
  '';
in {
  inherit defaultConfig configsDir;

  # Export for use in container configuration
  configs = {
    default = defaultConfig;
  };
}
