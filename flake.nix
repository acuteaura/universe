{
  description = "aurelia's universe flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic-unstable.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    eden.url = "github:acuteaura/eden-flake";
    flake-utils.url = "github:numtide/flake-utils";
    quadlet.url = "github:SEIAROTg/quadlet-nix";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";

    gpd-fan-unstable = {
      url = "github:Cryolitia/gpd-fan-driver";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    jovian-nixos-unstable = {
      follows = "chaotic-unstable/jovian";
    };

    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    home-manager-unstable,
    nix-flatpak,
    ...
  }: let
    packageOverlay = final: prev: {
      kwin-effects-forceblur = inputs.kwin-effects-forceblur.packages."${final.system}".default;
    };
    nixpkgsConfig = import ./nixpkgs-config.nix {
      getName = nixpkgs.lib.getName;
      extraOverlays = [
        packageOverlay
        inputs.eden.overlays.default
      ];
    };
    unstable = import nixpkgs-unstable {
      system = "x86_64-linux";
      config = nixpkgsConfig.nixpkgs.config;
      overlays = nixpkgsConfig.nixpkgs.overlays;
    };
    unstable-darwin = import nixpkgs-unstable {
      system = "aarch64-darwin";
      config = nixpkgsConfig.nixpkgs.config;
      overlays = nixpkgsConfig.nixpkgs.overlays;
    };
  in
    {
      nixosConfigurations = {
        cyberdaemon = import ./basesystem.nix {
          inherit nixpkgs nixpkgs-unstable nix-flatpak home-manager home-manager-unstable nixpkgsConfig;
          useUnstable = true;
          nixos-imports = [
            ./systems/cyberdaemon
            inputs.gpd-fan-unstable.nixosModules.default
            inputs.jovian-nixos-unstable.nixosModules.jovian
            inputs.chaotic-unstable.nixosModules.default
            {
              hardware.gpd-fan.enable = true;
            }
          ];
          home-manager-imports = [
            ./home-manager/shell.nix
            ./home-manager/desktop.nix
          ];
        };
        construct = import ./basesystem.nix {
          inherit nixpkgs nixpkgs-unstable nix-flatpak home-manager home-manager-unstable nixpkgsConfig;
          useUnstable = true;
          nixos-imports = [./systems/construct];
          home-manager-imports = [
            ./home-manager/shell.nix
            ./home-manager/desktop.nix
          ];
        };
        chariot = import ./basesystem.nix {
          inherit nixpkgs nixpkgs-unstable nix-flatpak home-manager home-manager-unstable nixpkgsConfig;
          useUnstable = true;
          nixos-imports = [
            ./systems/chariot
            inputs.chaotic-unstable.nixosModules.default
          ];
          home-manager-imports = [
            ./home-manager/shell.nix
            ./home-manager/desktop.nix
          ];
        };
        fool = import ./basesystem.nix {
          inherit nixpkgs nixpkgs-unstable nix-flatpak home-manager home-manager-unstable nixpkgsConfig;
          useUnstable = true;
          nixos-imports = [
            inputs.chaotic-unstable.nixosModules.default
            inputs.lanzaboote.nixosModules.lanzaboote
            ./systems/fool
          ];
          home-manager-imports = [
            ./home-manager/shell.nix
            ./home-manager/desktop.nix
          ];
        };
        bootstrap = import ./basesystem.nix {
          inherit nixpkgs nixpkgs-unstable nix-flatpak home-manager home-manager-unstable nixpkgsConfig;
          system = "aarch64-linux";
          nixos-imports = [
            inputs.quadlet.nixosModules.quadlet
            ./systems/bootstrap
          ];
          home-manager-imports = [
            ./home-manager/shell.nix
          ];
        };
        wsl = import ./basesystem.nix {
          inherit nixpkgs nixpkgs-unstable nix-flatpak home-manager home-manager-unstable nixpkgsConfig;
          nixos-imports = [./systems/wsl];
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
          extraSpecialArgs = {unstable = unstable;};
          modules = [
            (import ./basehmuser.nix {
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
          extraSpecialArgs = {unstable = unstable;};
          modules = [
            (import ./basehmuser.nix {
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
          extraSpecialArgs = {unstable = unstable-darwin;};
          modules = [
            (import ./basehmuser.nix {
              home-manager-imports = [nixpkgsConfig ./home-manager/shell.nix];
              home-manager-username = "aurelia";
              home-manager-homedir = "/Users/aurelia";
            })
          ];
        };
      };
      nixosModules.constants = import ./constants.nix;
    }
    // inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          system = "${system}";
        };
      in {
        formatter = pkgs.alejandra;
      }
    );
}
