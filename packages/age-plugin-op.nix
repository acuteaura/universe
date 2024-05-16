{ pkgs, ... }:
pkgs.buildGoModule {
  pname = "age-plugin-op";
  version = "0.1.0";
  rev = "";
  src = builtins.fetchGit {
    url = "https://github.com/bromanko/age-plugin-op.git";
    ref = "refs/tags/v0.1.0";
    rev = "fd26b1a6f3d88aa7e931d227690989a6fd6f00a0";
  };
  vendorHash = "sha256-dhJdLYy/CDqZuF5/1v05/ZEp+cWJ6V4GnVCf+mUr1MU=";
  CGO_ENABLED = 0;
}
