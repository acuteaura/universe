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

    jovian-nixos.url = "github:Jovian-Experiments/Jovian-NixOS";
    jovian-nixos.inputs.nixpkgs.follows = "nixpkgs-unstable";

    kwin-effects-forceblur.url = "github:taj-ny/kwin-effects-forceblur";
    kwin-effects-forceblur.inputs.nixpkgs.follows = "nixpkgs-unstable";
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
      aptakube = self.packages.aptakube;
      headlamp = self.packages.headlamp;
      yuzu = self.packages.yuzu;
      handheld-daemon = self.packages.hhd;
      adjustor = self.packages.hhd-adjustor;
    };
    nixpkgsConfig = import ./nixpkgs-config.nix {
      getName = nixpkgs.lib.getName;
      extraOverlays = [packageOverlay];
    };
    unstable = import nixpkgs-unstable {
      config = nixpkgsConfig;
      system = "x86_64-linux";
    };
    unstable-darwin = import nixpkgs-unstable {
      config = nixpkgsConfig;
      system = "aarch64-darwin";
    };
  in
    {
      nixosConfigurations = {
        cyberdaemon = import ./basesystem.nix {
          inherit nixpkgs nixpkgs-unstable nix-flatpak home-manager home-manager-unstable nixpkgsConfig;
          useUnstable = true;
          nixos-imports = [
            ./systems/cyberdaemon
            inputs.gpd-fan.nixosModules.default
            inputs.jovian-nixos.nixosModules.jovian
            {
              hardware.gpd-fan.enable = true;
            }
          ];
          home-manager-imports = [
            ./home-manager/shell.nix
          ];
        };
        chariot = import ./basesystem.nix {
          inherit nixpkgs nixpkgs-unstable nix-flatpak home-manager home-manager-unstable nixpkgsConfig;
          useUnstable = false;
          nixos-imports = [./systems/chariot];
          home-manager-imports = [
            ./home-manager/shell.nix
          ];
        };
        fool = import ./basesystem.nix {
          inherit nixpkgs nixpkgs-unstable nix-flatpak home-manager home-manager-unstable nixpkgsConfig;
          useUnstable = true;
          nixos-imports = [
            ./systems/fool
          ];
          home-manager-imports = [
            ./home-manager/shell.nix
            ./home-manager/desktop.nix
          ];
        };
        thassa = import ./basesystem.nix {
          inherit nixpkgs nixpkgs-unstable nix-flatpak home-manager home-manager-unstable nixpkgsConfig;
          nixos-imports = [
            inputs.quadlet.nixosModules.quadlet
            ./systems/thassa
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
      homeConfigurations = {
        shell-x86_64-linux = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit unstable;};
          modules = [
            (import ./basehm.nix {
              inherit nixpkgsConfig;
              home-manager-imports = [./homes/shell.nix];
              home-manager-username = "aurelia";
              home-manager-homedir = "/home/aurelia";
            })
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
      packages.aptakube = unstable.callPackage ./packages/aptakube.nix {};
      packages.headlamp = unstable.callPackage ./packages/headlamp.nix {};
      packages.hhd = unstable.callPackage ./packages/hhd.nix {};
      packages.hhd-adjustor = unstable.callPackage ./packages/hhd-adjustor.nix {};
      packages.yuzu = unstable.callPackage ./packages/yuzu {};
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
