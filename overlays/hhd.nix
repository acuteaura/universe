final: prev: {
  # override version
  hhd = prev.hhd.overrideAttrs (oldAttrs: rec {
    version = "3.19.22";
    src = final.fetchFromGitHub {
      owner = "hhd-dev";
      repo = "hhd";
      tag = "${version}";
      hash = "sha256-+Yk6mY6V1p5nUu0Y6O1b2V1+1Jqz1Z1V2H3K4L5M6N7O=";
    };
    dependencies = oldAttrs.dependencies ++ [final.adjustor];
  });
}
