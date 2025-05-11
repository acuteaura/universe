final: prev: {
  libfprint = prev.libfprint.overrideAttrs (old: {
    version = "git";

    src = final.fetchFromGitHub {
      owner = "ddlsmurf";
      repo = "libfprint-CS9711";
      rev = "03ace5b20146eb01c77fb3ea63e1909984d6d377";
      sha256 = "sha256-gr3UvFB6D04he/9zawvQIuwfv0B7fEZb6BGiNAbLids=";
    };

    nativeBuildInputs =
      old.nativeBuildInputs
      ++ [
        final.opencv
        final.cmake
        final.doctest
        final.nss
      ];
  });
}
