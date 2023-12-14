{
  description = "aurelia's universe flake";

  inputs = {
  };

  outputs = { self, nixpkgs }: {
    nixosModules = {
      default = ./configuration.nix;
      tranquility = ./systems/tranquility.nix;
    };
  };
}