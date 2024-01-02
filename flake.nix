{
  description = "aurelia's universe flake";

  inputs = {
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils }:
    {
      nixosModules = {
        tranquility = ./systems/tranquility;
        wsl = ./systems/wsl;
      };
      templates.default.path = ./template;
      packages.x86_64-linux = {
        apisix-ingress-controller =
          let
            pkgs = import nixpkgs { system = "x86_64-linux"; };
          in
          pkgs.callPackage ./packages/apisix-ingress-controller.nix { };
      };
      nixosConfigurations.lambdacore =
        let
          unstable = import nixpkgs-unstable { config.allowUnfree = true; system = "x86_64-linux"; };
        in
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit unstable; };
          modules = [
            ./systems/lambdacore
          ];
        };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
