{
  nixpkgs,
  nixpkgsConfig,
  constants,
  home-manager,
  extraSpecialArgs ? { },
  system ? "x86_64-linux",
}:
let
  systemFunc = nixpkgs.lib.nixosSystem;
  homeManagerModule = home-manager.nixosModules.home-manager;
  defaultSystem = system;
in
{
  nixos-imports ? [ ],
  home-manager-imports ? [ ],
  home-manager-username ? "aurelia",
  home-manager-homedir ? "/home/aurelia",
  system ? defaultSystem,
}:
systemFunc {
  specialArgs = extraSpecialArgs // {
    inherit constants;
  };
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
