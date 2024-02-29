{
  description = "aurelia's universe flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
    quadlet-nix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, flake-utils, nixos-generators, quadlet-nix }:
    let
      pkgs = import nixpkgs {
        config.allowUnfree = true;
        system = "x86_64-linux";
        config.permittedInsecurePackages = [ "electron-25.9.0" ];
      };
      unstable = import nixpkgs-unstable {
        config.allowUnfree = true;
        system = "x86_64-linux";
        config.permittedInsecurePackages = [ "electron-25.9.0" ];
      };
    in
    {
      nixosConfigurations.framework =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit unstable; inherit pkgs; };
          modules = [
            ./systems/framework
            quadlet-nix.nixosModules.quadlet
          ];
        };
      homeConfigurations.framework = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        modules = [
          ./homes/framework
        ];
        extraSpecialArgs = { inherit unstable; };
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs-unstable { config.allowUnfree = true; system = "${system}"; };
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        packages.apisix-ingress-controller = pkgs.callPackage ./packages/apisix-ingress-controller.nix { };

        packages.vm-image =
          let
            unstable = import nixpkgs-unstable { config.allowUnfree = true; system = "${system}"; };
            pkgs = unstable;
          in
          nixos-generators.nixosGenerate {
            system = "${system}";
            format = "qcow";
            modules = [
              ./systems/vps
            ];
            specialArgs = { inherit unstable; };
          };

        packages.apisix-ingress-docker =
          let
            pkgs = import nixpkgs { config.allowUnfree = true; system = "${system}"; };
          in
          pkgs.dockerTools.buildImage {
            name = "apisix-ingress-controller";
            config = {
              Cmd = [ "${self.packages.x86_64-linux.apisix-ingress-controller}/bin/apisix-ingress-controller" ];
            };
          };

      }
    );
}
