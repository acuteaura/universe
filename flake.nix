{
  description = "aurelia's universe flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs-unstable";

    quadlet = {
      url = "github:SEIAROTg/quadlet-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    home-manager-unstable,
    nixos-wsl,
    ...
  }: let
    nixpkgsConfig = {
      nixpkgs.config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "python3.11-django-3.1.14"
          "python3.12-django-3.1.14"
        ];
      };
      nixpkgs.overlays = [
        (import ./overlays/brave.nix)
      ];
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
      nixosConfigurations.cyberdaemon = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit unstable;};
        modules = [
          ./systems/cyberdaemon
          nixpkgsConfig
          home-manager-unstable.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aurelia = import ./homes/cyberdaemon.nix;
            home-manager.extraSpecialArgs = {inherit unstable;};
          }
        ];
      };
      nixosConfigurations.chariot = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit unstable;};
        modules = [
          ./systems/chariot
          nixpkgsConfig
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aurelia = import ./homes/chariot.nix;
            home-manager.extraSpecialArgs = {inherit unstable;};
          }
        ];
      };
      nixosConfigurations.fool = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit unstable;};
        modules = [
          ./systems/fool
          nixpkgsConfig
          home-manager-unstable.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aurelia = import ./homes/fool.nix;
            home-manager.extraSpecialArgs = {inherit unstable;};
          }
        ];
      };
      nixosConfigurations.thassa = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {};
        modules = [
          ./systems/thassa
          nixpkgsConfig
          inputs.quadlet.nixosModules.quadlet
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aurelia = import ./homes/shell-linux.nix;
            home-manager.extraSpecialArgs = {inherit unstable;};
          }
        ];
      };
      nixosConfigurations.wsl = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit unstable;};
        modules = [
          ./systems/wsl
          nixos-wsl.nixosModules.default
          nixpkgsConfig
          home-manager-unstable.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aurelia = import ./homes/shell-linux.nix;
            home-manager.extraSpecialArgs = {inherit unstable;};
          }
        ];
      };
      homeConfigurations.shell-x86_64-linux = home-manager-unstable.lib.homeManagerConfiguration {
        pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit unstable;};
        modules = [
          ./homes/shell-linux.nix
          nixpkgsConfig
        ];
      };
      homeConfigurations.shell-fat-x86_64-linux = home-manager-unstable.lib.homeManagerConfiguration {
        pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit unstable;};
        modules = [
          ./homes/shell-fat-linux.nix
          nixpkgsConfig
        ];
      };
      homeConfigurations.shell-devcontainer = home-manager-unstable.lib.homeManagerConfiguration {
        pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit unstable;};
        modules = [
          ./homes/shell-devcontainer.nix
          nixpkgsConfig
        ];
      };
      homeConfigurations.shell-nas = home-manager-unstable.lib.homeManagerConfiguration {
        pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit unstable;};
        modules = [
          ./homes/shell-nas.nix
          nixpkgsConfig
        ];
      };
      homeConfigurations.shell-aarch64-darwin = home-manager-unstable.lib.homeManagerConfiguration {
        pkgs = nixpkgs-unstable.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {unstable = unstable-darwin;};
        modules = [
          ./homes/shell-darwin.nix
          nixpkgsConfig
        ];
      };
    }
    // inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          config.allowUnfree = true;
          system = "${system}";
        };
      in {
        formatter = pkgs.alejandra;
      }
    );
}
