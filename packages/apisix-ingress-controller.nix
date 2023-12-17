{ lib
, buildGoModule
, fetchFromGitHub
}:
let
  version = "1.7.1"
  gitCommit = "ceefeb1e2547100679556a1763d9820ec04f6381"
in
  buildGoModule rec {
    pname = "apisix-ingress-controller";
    version = "${version}";

    src = fetchFromGitHub {
      owner = "apache";
      repo = "apisix-ingress-controller";
      rev = "${version}";
      hash = "sha256-C77ps1rVVGGRLnQdfNdyWISL5iWtLPKAiTfY2EYMmjM=";
    };

    subPackages = ["."];

    ldflags = [
      "-X github.com/apache/apisix-ingress-controller/pkg/version._buildVersion=${version}"
      "-X github.com/apache/apisix-ingress-controller/pkg/version._buildGitRevision=${gitCommit}"
      "-X github.com/apache/apisix-ingress-controller/pkg/version._buildOS=unknown"
    ];

    vendorHash = "sha256-kyU8izqI9kweiXsDxlEfZTiWKODnaccq1xC5nV06+/c=";

    CGO_ENABLED = 0;

    meta = with lib; {
      description = " APISIX Ingress Controller for Kubernetes";
      homepage = "https://github.com/apache/apisix-ingress-controller";
      license = licenses.asl20;
    };
  }