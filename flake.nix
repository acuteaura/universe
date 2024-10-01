{
  description = "aurelia's universe flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    quadlet = {
      url = "github:SEIAROTg/quadlet-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, home-manager-unstable, ... }:
    let
      nixpkgsConfig = {
        nixpkgs.config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "python3.11-django-3.1.14"
          ];
        };
      };
      unstable = import nixpkgs-unstable { config.allowUnfree = true; system = "x86_64-linux"; };
    in
    {
      nixosConfigurations.nivix =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { age-plugin-op = self.packages.x86_64-linux.age-plugin-op; inherit unstable; };
          modules = [
            ./systems/nivix
            #inputs.lix-module.nixosModules.default
            nixpkgsConfig
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.aurelia = import ./homes/nivix;
              home-manager.extraSpecialArgs = { inherit unstable; };
            }
          ];
        };
      nixosConfigurations.thassa =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { };
          modules = [
            ./systems/thassa
            nixpkgsConfig
            inputs.quadlet.nixosModules.quadlet
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.aurelia = import ./homes/shell-linux;
            }
          ];
        };
      homeConfigurations.nivix = home-manager-unstable.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./homes/nivix
          nixpkgsConfig
        ];
      };
      homeConfigurations.shell-x86_64-linux = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./homes/shell-linux
          nixpkgsConfig
        ];
      };
      homeConfigurations.shell-aarch64-darwin = home-manager-unstable.lib.homeManagerConfiguration {
        pkgs = nixpkgs-unstable.legacyPackages.aarch64-darwin;
        modules = [
          ./homes/shell-darwin
          nixpkgsConfig
        ];
      };
    } // inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { config.allowUnfree = true; system = "${system}"; };
      in
      {
        formatter = pkgs.nixpkgs-fmt;
        packages.age-plugin-op = pkgs.callPackage ./packages/age-plugin-op.nix { };
      }
    );
}
