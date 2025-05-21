# broken: uses <nixpkgs> and can't be overwritten
self: super: {
  waydroid_script = import (super.fetchFromGitHub {
    owner = "casualsnek";
    repo = "waydroid_script";
    rev = "1a2d3ad643206ad5f040e0155bb7ab86c0430365";
    sha256 = "sha256-OiZO62cvsFyCUPGpWjhxVm8fZlulhccKylOCX/nEyJU=";
  });
}
