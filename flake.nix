{
  description = "aurelia's universe flake";

  inputs = {
  };

  outputs = { self, nixpkgs }: {
    nixosModules = [
      import <configuration.nix>
    ];
  };
}