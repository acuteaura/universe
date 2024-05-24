{
  description = "aurelia's universe flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    lix.url = "git+https://git@git.lix.systems/lix-project/lix?ref=refs/tags/2.90-beta.1";
    lix.flake = false;

    lix-module.url = "git+https://git.lix.systems/lix-project/nixos-module";
    lix-module.inputs.lix.follows = "lix";
    lix-module.inputs.nixpkgs.follows = "nixpkgs-unstable";
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
    in
    {
      nixosConfigurations.nivix =
        nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { age-plugin-op = self.packages.x86_64-linux.age-plugin-op; };
          modules = [
            ./systems/nivix
            inputs.lix-module.nixosModules.default
            nixpkgsConfig
            home-manager-unstable.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.aurelia = import ./homes/nivix;
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
          ];
        };
      homeConfigurations.nivix = home-manager-unstable.lib.homeManagerConfiguration {
        pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
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
          ./homes/shell-darwins
          nixpkgsConfig
        ];
      };
    } // inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { config.allowUnfree = true; system = "${system}"; };
      in
      {
        formatter = pkgs.nixpkgs-fmt;
        packages.apisix-ingress-controller = pkgs.callPackage ./packages/apisix-ingress-controller.nix { };
        packages.age-plugin-op = pkgs.callPackage ./packages/age-plugin-op.nix { };
      }
    );
}
