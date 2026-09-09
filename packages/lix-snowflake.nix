{
  lib,
  stdenvNoCC,
  fetchurl,
  librsvg,
}: let
  iconName = "lix-snowflake";
in
  stdenvNoCC.mkDerivation {
    pname = "${iconName}-icon";
    version = "0-unstable-2026-06-04";

    src = fetchurl {
      url = "https://lix.systems/images/ecosystem-nixpkgs.svg";
      hash = "sha256-gdJtda+ztOaL3XSuxkkmMN7T8S4RVM64n8/kttsJogc=";
    };

    nativeBuildInputs = [librsvg];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      for size in 16 22 24 32 48 64 128 256; do
        mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps/
        rsvg-convert $src -w $size -h $size -o $out/share/icons/hicolor/''${size}x''${size}/apps/${iconName}.png
      done

      install -D -m444 $src $out/share/icons/hicolor/scalable/apps/${iconName}.svg

      runHook postInstall
    '';
  }
