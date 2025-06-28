self: super: {
  handheld-daemon = super.callPackage ../packages/hhd.nix {};
  adjustor = super.callPackage ../packages/adjustor.nix {};
}
