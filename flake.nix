{
  description = "aurelia's universe flake";

  inputs = {
    # base imports
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
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
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    affinity-nix.url = "github:mrshmllow/affinity-nix";
    eden.url = "github:acuteaura-forks/eden-flake";

    mistral-vibe = {
      url = "github:mistralai/mistral-vibe";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
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
      system = final.stdenv.hostPlatform.system;
    in {
      mistral-vibe = inputs.mistral-vibe.packages.${system}.default;
      zen = inputs.zen-browser.packages.${system}.default;
      kwin-effects-better-blur-dx-wayland = inputs.kwin-effects-better-blur-dx.packages.${system}.default;
      affinity = inputs.affinity-nix.packages.${system};
      michroma = prev.callPackage ./packages/michroma.nix {};
      nix-snowflake-pride = prev.callPackage ./packages/nix-snowflake-pride.nix {};
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
        cyberdaemon = baseSystem {
          nixos-imports = [
            ./systems/cyberdaemon
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.chaotic.nixosModules.default
            inputs.jovian.nixosModules.jovian
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.quadlet.nixosModules.quadlet
            inputs.eden.nixosModules.default
          ];
          home-manager-imports = [
            ./home-manager/shell.nix
            ./home-manager/desktop.nix
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
          ];
        };
        chariot = baseSystem {
          nixos-imports = [
            ./systems/chariot
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.chaotic.nixosModules.default
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.quadlet.nixosModules.quadlet
            inputs.eden.nixosModules.default
          ];
          home-manager-imports = [
            ./home-manager/shell.nix
            ./home-manager/desktop.nix
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
          ];
        };
        fool = baseSystem {
          nixos-imports = [
            ./systems/fool
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.quadlet.nixosModules.quadlet
            inputs.eden.nixosModules.default
          ];
          home-manager-imports = [
            ./home-manager/shell.nix
            ./home-manager/desktop.nix
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
          ];
        };
        bootstrap = baseSystem {
          system = "aarch64-linux";
          nixos-imports = [
            ./systems/bootstrap
            inputs.chaotic.nixosModules.default
            inputs.quadlet.nixosModules.quadlet
          ];
          home-manager-imports = [
            ./home-manager/shell.nix
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
            nixfmt-rfc-style
          ];
        };
      }
    );
}
