{
  description = "aurelia's universe flake";

  inputs = {
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable }: {
    nixosModules = {
      default = ./configuration.nix;
      tranquility = ./systems/tranquility;
    };
  };
}