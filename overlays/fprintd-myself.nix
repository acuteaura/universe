final: prev: {
  libfprint = prev.libfprint.overrideAttrs (old: {
    version = "git";

    src = final.fetchFromGitHub {
      owner = "ericlinagora";
      repo = "libfprint-CS9711";
      rev = "c242a40fcc51aec5b57d877bdf3edfe8cb4883fd";
      sha256 = "sha256-WFq8sNitwhOOS3eO8V35EMs+FA73pbILRP0JoW/UR80=";
    };

    nativeBuildInputs =
      old.nativeBuildInputs
      ++ [
        final.opencv
        final.cmake
        final.doctest
      ];
  });
}
