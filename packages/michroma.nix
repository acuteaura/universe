{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "michroma";
  version = "0-unstable-2024-12-19";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "Michroma-font";
    rev = "8602c0e9a86c0aa6529cc861926bf727568dcac8";
    hash = "sha256-lDJc3X4vBhW1EHNijbEuavhV3ViLLthIQE/6MS0+3H4=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/truetype fonts/ttf/*.ttf

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/googlefonts/Michroma-font";
    description = "Display typeface designed for high resolution screens";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
