{ lib
, buildGoModule
}:

buildGoModule rec {
  pname = "apisix-ingress-controller";
  version = "1.8.2";
  rev = "57b5aee6e7b9d386337ffe439d2e59f2d4ea0fe5";

  src = builtins.fetchGit {
    url = "git@github.com:apache/apisix-ingress-controller.git";
    ref = "refs/tags/v${version}";
    rev = "${rev}";
  };

  subPackages = [ "." ];

  ldflags = [
    "-X github.com/apache/apisix-ingress-controller/pkg/version._buildVersion=${version}"
    "-X github.com/apache/apisix-ingress-controller/pkg/version._buildGitRevision=${rev}"
    "-X github.com/apache/apisix-ingress-controller/pkg/version._buildOS=nixDerivationStrict"
  ];

  vendorHash = "sha256-A3Yh4KybsveKxW7RXHHTZJHqql2QYClNlQam8tpYXb0=";

  CGO_ENABLED = 0;

  meta = with lib; {
    description = " APISIX Ingress Controller for Kubernetes";
    homepage = "https://github.com/apache/apisix-ingress-controller";
    license = licenses.asl20;
  };
}
