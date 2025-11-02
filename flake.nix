{
  description = "aurelia's universe flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };

    winapps-unstable = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    eden.url = "github:Grantimatter/eden-flake";
    flake-utils.url = "github:numtide/flake-utils";
    quadlet.url = "github:SEIAROTg/quadlet-nix";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";

    jovian = {
      follows = "chaotic/jovian";
    };

    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-flatpak,
      ...
    }:
    let
      packageOverlay = final: prev: {
        kwin-effects-forceblur = inputs.kwin-effects-forceblur.packages."${final.system}".default;
        winapps = inputs.winapps-unstable.packages."${final.system}".winapps;
        winapps-launcher = inputs.winapps-unstable.packages."${final.system}".winapps-launcher;
      };
      nixpkgsConfig = import ./nixpkgs-config.nix {
        getName = nixpkgs.lib.getName;
        extraOverlays = [
          packageOverlay
        ];
      };
      unstable = import nixpkgs {
        system = "x86_64-linux";
        config = nixpkgsConfig.nixpkgs.config;
        overlays = nixpkgsConfig.nixpkgs.overlays;
      };
      unstable-darwin = import nixpkgs {
        system = "aarch64-darwin";
        config = nixpkgsConfig.nixpkgs.config;
        overlays = nixpkgsConfig.nixpkgs.overlays;
      };

      baseSystem = import ./util/basesystem.nix {
        inherit
          nixpkgs
          home-manager
          nixpkgsConfig
          ;
        constants = self.nixosModules.constants;
      };
    in
    {
      nixosConfigurations = {
        cyberdaemon = baseSystem {
          nixos-imports = [
            ./systems/cyberdaemon
            inputs.chaotic.nixosModules.default
            inputs.jovian.nixosModules.jovian
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.quadlet.nixosModules.quadlet
            inputs.eden.nixosModules.default
          ];
          home-manager-imports = [
            ./home-manager/shell.nix
            ./home-manager/desktop.nix
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
          ];
        };
        fool = baseSystem {
          nixos-imports = [
            ./systems/fool
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.chaotic.nixosModules.default
            inputs.lanzaboote-unstable.nixosModules.lanzaboote
            inputs.quadlet.nixosModules.quadlet
            inputs.eden.nixosModules.default
          ];
          home-manager-imports = [
            ./home-manager/shell.nix
            ./home-manager/desktop.nix
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
        wsl = baseSystem {
          nixos-imports = [ ./systems/wsl ];
          home-manager-imports = [
            ./home-manager/shell.nix
          ];
        };
      };
      homeConfigurations =
        let
          nix-flatpak-module = nix-flatpak.homeManagerModules.nix-flatpak;
        in
        {
          shell-x86_64-linux = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = {
              unstable = unstable;
            };
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
            extraSpecialArgs = {
              unstable = unstable;
            };
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
            extraSpecialArgs = {
              unstable = unstable-darwin;
            };
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
      nixosModules.constants = import ./constants.nix;
    }
    // inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          system = "${system}";
        };
      in
      {
        formatter = pkgs.alejandra;
      }
    );
}
