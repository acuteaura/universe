# omg how do i use this

### /etc/nixos/flake.nix

```nix
{
  description = "system flake";

  inputs = {
    universe = {
      type = "github";
      owner = "acuteaura";
      repo = "universe";
    };
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs, nixpkgs-unstable, universe }: {
    nixosConfigurations.tranquility = let
      system = "x86_64-linux";
      pkgs = import nixpkgs { config.allowUnfree = true; };
      unstable = import nixpkgs-unstable { config.allowUnfree = true; system = system; };
      hashedPassword = "<you mkpasswd your own, friend>";
    in
      nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = { inherit unstable; inherit hashedPassword; };
        modules = [
          universe.nixosModules.default
          universe.nixosModules.tranquility
          ./hardware-configuration.nix
        ];
      };
  };
}
```

wow it's like i'm finally getting the hang of nix