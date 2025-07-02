{
  nixpkgs,
  nixpkgs-unstable,
  nixpkgsConfig,
  nixos-imports ? [],
  home-manager,
  home-manager-unstable,
  home-manager-imports ? [],
  home-manager-username ? "aurelia",
  home-manager-homedir ? "/home/aurelia",
  useUnstable ? false,
  system ? "x86_64-linux",
  nix-flatpak ? {},
  ...
}: let
  unstable = import nixpkgs-unstable {
    system = system;
    config = nixpkgsConfig;
  };
  defaultPkgs = import nixpkgs {
    system = system;
    config = nixpkgsConfig;
  };

  systemFunc =
    if useUnstable
    then nixpkgs-unstable.lib.nixosSystem
    else nixpkgs.lib.nixosSystem;

  pkgs =
    if useUnstable
    then nixpkgs-unstable.legacyPackages."${system}"
    else nixpkgs.legacyPackages."${system}";

  homeManagerModule =
    if useUnstable
    then home-manager-unstable.nixosModules.home-manager
    else home-manager.nixosModules.home-manager;
in
  systemFunc {
    system = system;
    specialArgs = {inherit unstable;};
    modules =
      [
        nix-flatpak.nixosModules.nix-flatpak
        nixpkgsConfig
        homeManagerModule
        (import ./basehm.nix {
          inherit nixpkgsConfig home-manager-imports home-manager-username home-manager-homedir;
          extraSpecialArgs = {inherit unstable;};
        })
      ]
      ++ nixos-imports;
  }
