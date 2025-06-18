{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rose-pine-kde-colors";
  version = "0.0.0-unstable-1";

  src = fetchFromGitHub {
    owner = "ashbork";
    repo = "kde";
    rev = "e09016d12b28254d6e64c9c1ff315a088b1502a4";
    hash = "sha256-sTLbOQBVXG6Oz9Gm0iyvfklkbi8qxtg0C+4k28bf6WA=";
  };

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/color-schemes/
    IFS=$'\n'
    COLOR_FILES=$(find . -iname "*.colors")
    for i in $COLOR_FILES; do
      cp "$i" $out/share/color-schemes/
    done
    rm $out/share/color-schemes/template.colors

    runHook postInstall
  '';
})
