{
  description = "aurelia's universe flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, flake-utils }:
    let
      system = "x86_64-linux";
      config = {
        allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
          "1password"
          "1password-gui"
          "1password-cli"
          "steam"
          "steam-original"
          "steam-run"
          "goland"
          "obsidian"
          "vscode"
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
          specialArgs = { inherit unstable; pkgs = unstable; };
          modules = [
            ./systems/framework
          ];
        };
      homeConfigurations.framework = home-manager.lib.homeManagerConfiguration {
        pkgs = unstable;
        modules = [
          ./homes/framework
        ];
        extraSpecialArgs = { inherit unstable; };
      };
      homeConfigurations.wsl = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        modules = [
          ./homes/wsl
        ];
        extraSpecialArgs = { inherit unstable; };
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs-unstable { config.allowUnfree = true; system = "${system}"; };
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        packages.apisix-ingress-controller = pkgs.callPackage ./packages/apisix-ingress-controller.nix { };
      }
    );
}
