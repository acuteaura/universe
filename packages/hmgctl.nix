{ lib
, buildGoModule
}:

buildGoModule rec {
  pname = "hmgctl";
  version = "1.6.3";
  rev = "da325e541ab77ef91950a8eac6ef6663fabe099e";

  src = builtins.fetchGit {
    url = "https://handelsblattgroup@dev.azure.com/handelsblattgroup/Shared/_git/hmgctl";
    rev = "${rev}";
  };

  subPackages = [ "cmd/hmgctl" ];

  ldflags = [ ];

  vendorHash = null;

  CGO_ENABLED = 0;

  meta = with lib; {
    description = "hmgctl";
    homepage = "https://dev.azure.com/handelsblattgroup/Shared/_git/hmgctl";
    license = licenses.unfree;
  };
}
