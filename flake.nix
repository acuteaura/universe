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
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";

    gpd-fan.url = "github:Cryolitia/gpd-fan-driver";
    gpd-fan.inputs.nixpkgs.follows = "nixpkgs";
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
    nixpkgsConfig = {
      nixpkgs.config = {
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
        cyberdaemon = import ./basesystem.nix {
          inherit nixpkgs nixpkgs-unstable nix-flatpak;
          home-manager = home-manager-unstable;
          useUnstable = true;
          nixos-imports = [
            ./systems/cyberdaemon
            inputs.gpd-fan.nixosModules.default
            {
              hardware.gpd-fan.enable = true;
            }
          ];
          home-manager-imports = [
            ./home-manager/base.nix
            ./home-manager/shell.nix
          ];
        };
        chariot = import ./basesystem.nix {
          inherit nixpkgs nixpkgs-unstable nix-flatpak;
          home-manager = home-manager-unstable;
          useUnstable = true;
          nixos-imports = [./systems/chariot];
          home-manager-imports = [
            ./home-manager/base.nix
            ./home-manager/shell.nix
          ];
        };
        fool = import ./basesystem.nix {
          inherit nixpkgs nixpkgs-unstable home-manager nix-flatpak;
          nixos-imports = [./systems/fool];
          home-manager-imports = [
            ./home-manager/base.nix
            ./home-manager/shell.nix
            ./home-manager/desktop.nix
          ];
        };
        thassa = import ./basesystem.nix {
          inherit nixpkgs nixpkgs-unstable home-manager nix-flatpak;
          nixos-imports = [
            inputs.quadlet.nixosModules.quadlet
            ./systems/thassa
          ];
          home-manager-imports = [
            ./home-manager/base.nix
            ./home-manager/shell.nix
          ];
        };
        wsl = import ./basesystem.nix {
          inherit nixpkgs nixpkgs-unstable home-manager nix-flatpak;
          nixos-imports = [./systems/wsl];
          home-manager-imports = [
            ./home-manager/base.nix
            ./home-manager/shell.nix
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
