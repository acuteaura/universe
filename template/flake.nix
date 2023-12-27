{
  description = "OS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    #nixos-wsl = "github:nix-community/NixOS-WSL"

    universe = {
      type = "github";
      owner = "acuteaura";
      repo = "universe";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
      inputs.flake-utils.follows = "flake-utils"
    };
  };
  
  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-wsl, universe }: {
    nixosConfigurations.localhost = let
      system = "x86_64-linux";
      unstable = import nixpkgs-unstable { config.allowUnfree = true; system = system; };
      # "weaknesspays" - change this!
      hashedPassword = "$y$j9T$QBVVTbTT6gI9rUd/IkuaS1$onrwomnNgETdZ.r5urhLELlUBb7JSL9pQy2efAUCWh3";
    in
      nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = { inherit unstable; inherit hashedPassword; };
        modules = [
          #nixosModules.wsl
          universe.nixosModules.wsl

          # nixos-generate-config --show-hardware-config > hardware-configuration.nix
          ./hardware-configuration.nix
        ];
      };
  };
}