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
      apisix-ingress-controller = let
        pkgs = import nixpkgs { system = "x86_64-linux"; };
      in
        pkgs.callPackage ./packages/apisix-ingress-controller.nix {};
    };
    templates.default.path = ./template;
  };
}
