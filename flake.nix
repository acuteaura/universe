{
  description = "aurelia's universe flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, nixos-generators }:
    {
      nixosModules = {
        tranquility = ./systems/tranquility;
        wsl = ./systems/wsl;
      };
      nixosConfigurations.lambdacomplex =
        let
          unstable = import nixpkgs-unstable {  
            system = "x86_64-linux";
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                "electron-25.9.0"
              ];
            };
          };
          #pkgs = import nixpkgs { 
          #  config.allowUnfree = true;
          #  system = "x86_64-linux";
          #}
          pkgs = unstable;
        in
        nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit pkgs; inherit unstable; };
          modules = [
            ./systems/lambdacore
          ];
        };

      nixosConfigurations.tranquility =
        let
          unstable = import nixpkgs-unstable { config.allowUnfree = true; system = "x86_64-linux"; };
          pkgs = unstable;
        in
        nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit unstable; };
          modules = [
            ./systems/tranquility
          ];
        };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        packages.apisix-ingress-controller = pkgs.callPackage ./packages/apisix-ingress-controller.nix { };
        packages.hmgctl = pkgs.callPackage ./packages/hmgctl.nix { };

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
