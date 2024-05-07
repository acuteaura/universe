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
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, home-manager-unstable, flake-utils }:
    let
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "python3.11-django-3.1.14"
        ];
      };
      pkgs-x86_64-linux = import nixpkgs {
        system = "x86_64-linux";
        inherit config;
      };
      unstable-x86_64-linux = import nixpkgs-unstable {
        system = "x86_64-linux";
        inherit config;
      };
      pkgs-aarch64-darwin = import nixpkgs {
        system = "aarch64-darwin";
        inherit config;
      };
      unstable-aarch64-darwin = import nixpkgs-unstable {
        system = "aarch64-darwin";
        inherit config;
      };

    in
    {
      nixosConfigurations.nivix =
        nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            pkgs = unstable-x86_64-linux;
            unstable = unstable-x86_64-linux;
          };
          modules = [
            ./systems/nivix
          ];
        };
      nixosConfigurations.thassa =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            pkgs = pkgs-x86_64-linux;
            unstable = unstable-x86_64-linux;
          };
          modules = [
            ./systems/thassa
          ];
        };
      homeConfigurations.nivix = home-manager-unstable.lib.homeManagerConfiguration {
        pkgs = unstable-x86_64-linux;
        modules = [
          ./homes/nivix
        ];
        extraSpecialArgs = { unstable = unstable-x86_64-linux; };
      };
      homeConfigurations.shell-x86_64-linux = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-x86_64-linux;
        modules = [
          ./homes/shell-linux
        ];
        extraSpecialArgs = { unstable = unstable-x86_64-linux; };
      };
      homeConfigurations.shell-aarch64-darwin = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-aarch64-darwin;
        modules = [
          ./homes/shell-darwin
        ];
        extraSpecialArgs = { unstable = unstable-x86_64-linux; };
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { config.allowUnfree = true; system = "${system}"; };
      in
      {
        formatter = pkgs.nixpkgs-fmt;
        packages.apisix-ingress-controller = pkgs.callPackage ./packages/apisix-ingress-controller.nix { };
      }
    );
}
