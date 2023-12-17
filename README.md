# omg how do i use this

### /etc/nixos/flake.nix

```nix
{
  description = "A very basic OS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    universe = {
      type = "github";
      owner = "acuteaura";
      repo = "universe";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    };
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs, nixpkgs-unstable, universe }: {
    nixosConfigurations.tranquility = let
      system = "x86_64-linux";
      unstable = import nixpkgs-unstable { config.allowUnfree = true; system = system; };
      hashedPassword = "<redacted>";
    in
      nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = { inherit unstable; inherit hashedPassword; };
        modules = [
          universe.nixosModules.tranquility
          universe.nixosModules.desktop
          universe.nixosModules.base
          ./hardware-configuration.nix
        ];
      };
  };
}

```

wow it's like i'm finally getting the hang of nix