{defaultPkgs, ...}: {
  # let's have a dirty hack for fun
  nix.settings.system-features = ["benchmark" "big-parallel" "kvm" "nixos-test" "gccarch-znver4"];
  nixpkgs.hostPlatform = {
    gcc.arch = "znver4";
    gcc.tune = "znver4";
    system = "x86_64-linux";
  };
  # remove the tuning above for some packages
  nixpkgs.overlays = [
    (
      final: prev: {
        inherit (defaultPkgs) gsl;
        inherit (defaultPkgs) lib2geom;
        inherit (defaultPkgs) lkl;
        inherit (defaultPkgs) openldap;
        inherit (defaultPkgs) openblas;
        inherit (defaultPkgs) lix;

        inherit (defaultPkgs) gfortran;
      }
    )
  ];
}
