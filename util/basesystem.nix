{
  nixpkgs,
  nixpkgsConfig,
  constants,
  home-manager,
  extraSpecialArgs ? {},
  system ? "x86_64-linux",
}: let
  defaultSystem = system;
in
  {
    nixos-imports ? [],
    home-manager-imports ? [],
    home-manager-username ? "aurelia",
    home-manager-homedir ? "/home/aurelia",
    system ? defaultSystem,
  }:
    nixpkgs.lib.nixosSystem {
      specialArgs =
        extraSpecialArgs
        // {
          inherit constants;
        };
      inherit system;
      modules =
        [
          nixpkgsConfig
          home-manager.nixosModules.home-manager
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
