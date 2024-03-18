{
  description = "aurelia's universe flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils }:
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
          "obsidian"
          "vscode"
        ];
      };
      pkgs = import nixpkgs {
        inherit system;
        inherit config;
      };
      unstable = pkgs;
    in
    {
      nixosConfigurations.framework =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit pkgs; inherit unstable; };
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
        pkgs = import nixpkgs { config.allowUnfree = true; system = "${system}"; };
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        packages.apisix-ingress-controller = pkgs.callPackage ./packages/apisix-ingress-controller.nix { };
      }
    );
}
