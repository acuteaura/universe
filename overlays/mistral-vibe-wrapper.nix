final: prev: {
  mistral-vibe-wrapped = prev.stdenv.mkDerivation {
    pname = "mistral-vibe-wrapped";
    version = final.mistral-vibe.version or "unstable";

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin
      ln -s ${final.mistral-vibe}/bin/vibe $out/bin/vibe
      ln -s ${final.mistral-vibe}/bin/vibe-acp $out/bin/vibe-acp
    '';

    meta = {
      description = "Wrapped version of mistral-vibe with only vibe and vibe-acp binaries";
      mainProgram = "vibe";
    };
  };
}
