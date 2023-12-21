{
  description = "aurelia's universe flake";

  inputs = {
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable }: {
    nixosModules = {
      tranquility = ./systems/tranquility;
    };
    packages.x86_64-linux = {
      apisix-ingress-controller = nixpkgs.callPackage ./packages/apisix-ingress-controller.nix { };
    };
  };
}