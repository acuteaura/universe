final: prev: {
  # override version to 3.19.22 (unmerged PR: https://github.com/NixOS/nixpkgs/pull/453535)
  handheld-daemon = prev.handheld-daemon.overrideAttrs (oldAttrs: rec {
    version = "3.19.22";
    src = final.fetchFromGitHub {
      owner = "hhd-dev";
      repo = "hhd";
      tag = "v${version}";
      hash = "sha256-mvIB2lgFaHMCGEshKvagOFUrvcgEbyUS9VXJpXbvzTs=";
    };
  });
}
