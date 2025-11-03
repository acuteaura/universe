self: super: let
  oldPkgs =
    import (builtins.fetchTree {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "2c8d3f48d33929642c1c12cd243df4cc7d2ce434";
    }) {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
    };
in {
  inherit (oldPkgs) jetbrains;
}
