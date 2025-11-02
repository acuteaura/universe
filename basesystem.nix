{
  nixpkgs,
  nixpkgsConfig,
  nixos-imports ? [ ],
  home-manager,
  home-manager-imports ? [ ],
  home-manager-username ? "aurelia",
  home-manager-homedir ? "/home/aurelia",
  system ? "x86_64-linux",
  ...
}:
let
  systemFunc = nixpkgs.lib.nixosSystem;
  homeManagerModule = home-manager.nixosModules.home-manager;
in
systemFunc {
  system = system;
  modules = [
    nixpkgsConfig
    homeManagerModule
    (import ./basehm.nix {
      inherit
        nixpkgsConfig
        home-manager-imports
        home-manager-username
        home-manager-homedir
        ;
    })
  ]
  ++ nixos-imports;
}
