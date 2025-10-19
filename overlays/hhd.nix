final: prev: {
  # override version
  handheld-daemon = final.callPackage (import ../packages/hhd/package.nix) {
    extraDependencies = [
      final.adjustor
    ];
  };
  adjustor = final.callPackage (import ../packages/adjustor/default.nix) { };
}
