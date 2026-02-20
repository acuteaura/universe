{
  nixpkgs,
  nixpkgsConfig,
  constants,
  universe,
  home-manager,
  extraSpecialArgs ? {},
  system ? "x86_64-linux",
}: let
  defaultSystem = system;
  codeNameMap = {
    "26.05" = "Ancyor";
  };
  lib = nixpkgs.lib.extend (final: prev: {
    trivial =
      prev.trivial
      // {
        codeName = codeNameMap.${prev.trivial.release} or prev.trivial.codeName;
      };
  });
in
  {
    nixos-imports ? [],
    home-manager-imports ? [],
    home-manager-username ? "aurelia",
    home-manager-homedir ? "/home/aurelia",
    system ? defaultSystem,
  }:
    nixpkgs.lib.nixosSystem {
      inherit lib;
      specialArgs =
        extraSpecialArgs
        // {
          inherit constants;
        };
      inherit system;
      modules =
        [
          nixpkgsConfig
          universe
          ({pkgs, ...}: {
            system.nixos = {
              # 1password bonked me for this
              # no fun allowed
              # queer erasure
              # etc.
              #
              distroName = "Nix for Lesbians";
              extraOSReleaseArgs = {
                LOGO = "lesbiannixos";
                PRETTY_NAME = "Nix® for Lesbians";
              };
            };
            environment.systemPackages = [pkgs.nix-snowflake-pride];
          })
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
