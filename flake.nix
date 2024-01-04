{
  description = "aurelia's universe flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
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
      nixosConfigurations.lambdacore =
        let
          unstable = import nixpkgs-unstable { config.allowUnfree = true; system = "x86_64-linux"; };
          pkgs = unstable;
        in
        nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit pkgs; inherit unstable; };
          modules = [
            ./systems/lambdacore
          ];
        };

      nixosConfigurations.tranquility =
        let
          unstable = import nixpkgs-unstable { config.allowUnfree = true; system = "x86_64-linux"; };
          pkgs = unstable;
        in
        nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit unstable; };
          modules = [
            ./systems/tranquility
          ];
        };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        formatter = pkgs.nixpkgs-fmt;
        packages.apisix-ingress-controller = pkgs.callPackage ./packages/apisix-ingress-controller.nix { };
      }
    );
}
