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
        gsl = defaultPkgs.gsl;
        lib2geom = defaultPkgs.lib2geom;
        lkl = defaultPkgs.lkl;
        openldap = defaultPkgs.openldap;
        openblas = defaultPkgs.openblas;
        lix = defaultPkgs.lix;

        gfortran = defaultPkgs.gfortran;
      }
    )
  ];
}
