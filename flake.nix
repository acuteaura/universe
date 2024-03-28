{
  description = "aurelia's universe flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager-unstable, flake-utils }:
    let
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "python3.11-django-3.1.14"
        ];
      };
      pkgs = import nixpkgs {
        inherit system;
        inherit config;
      };
      unstable = import nixpkgs-unstable {
        inherit system;
        inherit config;
      };
    in
    {
      nixosConfigurations.framework =
        nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { pkgs = unstable; inherit unstable; };
          modules = [
            ./systems/framework
          ];
        };
      homeConfigurations.framework = home-manager-unstable.lib.homeManagerConfiguration {
        pkgs = unstable;
        modules = [
          ./homes/framework
        ];
        extraSpecialArgs = { inherit unstable; };
      };
      homeConfigurations.full-shell = home-manager-unstable.lib.homeManagerConfiguration {
        pkgs = pkgs;
        modules = [
          ./homes/full-shell
        ];
        extraSpecialArgs = { inherit unstable; };
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
