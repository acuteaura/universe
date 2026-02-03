final: prev: {
  fooyin = prev.fooyin.overrideAttrs (old: {
    version = "0.9.2-3791e37";
    src = prev.fetchFromGitHub {
      owner = "fooyin";
      repo = "fooyin";
      rev = "3791e370230281df069c23fd3b3cfafd6d5f1a8b";
      sha256 = "sha256-+1Ao45BM9cIOhoGQthkHj/CfcGjKGcqNqLSWIBjMmTQ=";
    };
    patches = [];
    postPatch = "";
  });
}
