{
  description = "aurelia's universe flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    quadlet.url = "github:SEIAROTg/quadlet-nix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    home-manager-unstable,
    ...
  }: let
    baseSystem = {
      system = "x86_64-linux";
      specialArgs = {inherit unstable;};
    };
    nixpkgsConfig = {
      nixpkgs.config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "python3.11-django-3.1.14"
          "python3.12-django-3.1.14"
        ];
      };
    };
    unstable = import nixpkgs-unstable {
      config.allowUnfree = true;
      system = "x86_64-linux";
    };
    unstable-darwin = import nixpkgs-unstable {
      config.allowUnfree = true;
      system = "aarch64-darwin";
    };
  in
    {
      nixosConfigurations = {
        cyberdaemon = nixpkgs-unstable.lib.nixosSystem {
          inherit (baseSystem) system specialArgs;
          modules = [
            ./systems/cyberdaemon
            (import ./basesystem.nix {
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              inherit unstable home-manager;
              home-manager-imports = [
                ./home-manager/base.nix
                ./home-manager/shell.nix
              ];
            })
          ];
        };
        chariot = inputs.nixpkgs.lib.nixosSystem {
          inherit (baseSystem) system specialArgs;
          modules = [
            ./systems/chariot
            (import ./basesystem.nix {
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              inherit unstable home-manager;
              home-manager-imports = [
                ./home-manager/base.nix
                ./home-manager/shell.nix
              ];
            })
          ];
        };
        fool = nixpkgs.lib.nixosSystem {
          inherit (baseSystem) system specialArgs;
          modules = [
            (import ./basesystem.nix {
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              inherit unstable home-manager;
              nixos-imports = [./systems/fool];
              home-manager-imports = [
                ./home-manager/base.nix
                ./home-manager/shell.nix
              ];
            })
          ];
        };
        thassa = nixpkgs.lib.nixosSystem {
          inherit (baseSystem) system specialArgs;
          modules = [
            ./systems/thassa
            (import ./basesystem.nix {
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              inherit unstable home-manager;
              home-manager-imports = [
                ./home-manager/base.nix
                ./home-manager/shell.nix
              ];
            })
            inputs.quadlet.nixosModules.quadlet
          ];
        };
        wsl = nixpkgs.lib.nixosSystem {
          inherit (baseSystem) system specialArgs;
          modules = [
            ./systems/wsl
            inputs.nixos-wsl.nixosModules.default
            (import ./basesystem.nix {
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              inherit unstable home-manager;
              home-manager-imports = [
                ./home-manager/base.nix
                ./home-manager/shell.nix
              ];
            })
          ];
        };
      };
      homeConfigurations = {
        shell-x86_64-linux = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit unstable;};
          modules = [
            ./home-manager/shell.nix
            nixpkgsConfig
          ];
        };
        shell-fat-x86_64-linux = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit unstable;};
          modules = [
            ./home-manager/shell.nix
            nixpkgsConfig
          ];
        };
        shell-devcontainer = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit unstable;};
          modules = [
            ./home-manager/shell.nix
            nixpkgsConfig
          ];
        };
        shell-nas = home-manager-unstable.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit unstable;};
          modules = [
            ./home-manager/shell.nix
            nixpkgsConfig
          ];
        };
        shell-aarch64-darwin = home-manager-unstable.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.aarch64-darwin;
          extraSpecialArgs = {unstable = unstable-darwin;};
          modules = [
            ./home-manager/shell.nix
            nixpkgsConfig
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
