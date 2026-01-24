{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation {
  pname = "nix-snowflake-pride";
  version = "0-unstable-2024-02-05";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/9d2cdedd73d64a068214482902adea3d02783ba8/logo/nix-snowflake-rainbow.svg";
    hash = "sha256-gMeJgiSSA5hFwtW3njZQAd4OHji6kbRCJKVoN6zsRbY=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D -m444 $src $out/share/icons/hicolor/scalable/apps/nix-snowflake-rainbow.svg

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/NixOS/nixos-artwork";
    description = "NixOS pride rainbow snowflake logo";
    license = lib.licenses.cc-by-40;
    platforms = lib.platforms.all;
  };
}
