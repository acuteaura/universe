self: super: let
  nixpkgs_gitversion_5_12 = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/edb3633f9100d9277d1c9af245a4e9337a980c07.tar.gz";
    sha256 = "sha256:0k4hh49402i126mjg1248hszi9ik95zlr6wxi491k5dizyc4xx6m";
  }) {system = super.system;};
in {
  gitversion = nixpkgs_gitversion_5_12.gitversion;
}
