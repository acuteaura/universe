{
  description = "aurelia's universe flake";

  inputs = {
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable }: {
    nixosModules = {
      tranquility = ./systems/tranquility;
      desktop = ./desktop.nix;
      base = ./base.nix;
    };
  };
}