{
  description = "aurelia's universe flake";

  inputs = {
    # base imports
    nixpkgs.url = "nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # platform
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    jovian.follows = "chaotic/jovian";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };
    # utils
    flake-utils.url = "github:numtide/flake-utils";
    quadlet.url = "github:SEIAROTg/quadlet-nix";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.7.0";
    # tools and apps
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kwin-effects-better-blur-dx = {
      url = "github:xarblu/kwin-effects-better-blur-dx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nix-flatpak,
    ...
  }: let
    packageOverlay = final: prev: let
      inherit (final.stdenv.hostPlatform) system;
    in {
      michroma = prev.callPackage ./packages/michroma.nix {};
      nix-snowflake-pride = prev.callPackage ./packages/nix-snowflake-pride.nix {};
      lix-snowflake = prev.callPackage ./packages/lix-snowflake.nix {};
    };
    nixpkgsConfig = import ./nixpkgs-config.nix {
      inherit (nixpkgs.lib) getName;
      extraOverlays = [
        packageOverlay
      ];
    };

    baseSystem = import ./util/basesystem.nix {
      inherit
        nixpkgs
        home-manager
        nixpkgsConfig
        ;
      inherit (self.nixosModules) constants universe;
    };
  in
    {
      nixosConfigurations = {
        chariot = baseSystem {
          nixos-imports = [
            ./systems/chariot
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.chaotic.nixosModules.default
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.quadlet.nixosModules.quadlet
          ];
          home-manager-imports = [
            ./home-manager/shell.nix
            ./home-manager/desktop.nix
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
          ];
        };
      };
      homeConfigurations = let
        nix-flatpak-module = nix-flatpak.homeManagerModules.nix-flatpak;
      in {
        shell-x86_64-linux = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            (import ./util/basehmuser.nix {
              home-manager-imports = [
                nixpkgsConfig
                nix-flatpak-module
                ./home-manager/shell.nix
              ];
              home-manager-username = "aurelia";
              home-manager-homedir = "/home/aurelia";
            })
          ];
        };
        desktop-x86_64-linux = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            (import ./util/basehmuser.nix {
              home-manager-imports = [
                nixpkgsConfig
                nix-flatpak-module
                ./home-manager/shell.nix
                ./home-manager/fonts.nix
                ./home-manager/desktop.nix
                ./home-manager/zed.nix
              ];
              home-manager-username = "aurelia";
              home-manager-homedir = "/home/aurelia";
            })
          ];
        };
        shell-aarch64-darwin = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [
            (import ./util/basehmuser.nix {
              home-manager-imports = [
                nixpkgsConfig
                ./home-manager/shell.nix
                ./home-manager/fonts.nix
                ./home-manager/zed.nix
              ];
              home-manager-username = "aurelia";
              home-manager-homedir = "/Users/aurelia";
            })
          ];
        };
      };
      nixosModules = {
        constants = import ./constants;
        universe = import ./modules;
      };
    }
    // inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          inherit (nixpkgsConfig.nixpkgs) config overlays;
        };
      in {
        formatter = pkgs.alejandra;

        apps.lint = {
          type = "app";
          program = "${pkgs.writeShellScript "lint" ''
            ${pkgs.statix}/bin/statix check "$@"
            ${pkgs.deadnix}/bin/deadnix --no-lambda-arg --no-lambda-pattern-names "$@"
          ''}";
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            alejandra
            statix
            deadnix
            nixfmt
          ];
        };
      }
    );
}
