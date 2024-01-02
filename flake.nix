{
  description = "aurelia's universe flake";

  inputs = {
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        nixosModules = {
          tranquility = ./systems/tranquility;
          wsl = ./systems/wsl;
        };
        packages.x86_64-linux = {
          apisix-ingress-controller =
            let
              pkgs = import nixpkgs { system = "x86_64-linux"; };
            in
            pkgs.callPackage ./packages/apisix-ingress-controller.nix { };
        };
        templates.default.path = ./template;
        formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      }
    );
}
