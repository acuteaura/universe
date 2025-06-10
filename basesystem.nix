{
  nixpkgs,
  nixpkgs-unstable,
  useUnstable ? false,
  system ? "x86_64-linux",
  nixos-imports ? [],
  home-manager,
  home-manager-imports ? [],
  home-manager-username ? "aurelia",
  home-manager-homedir ? "/home/aurelia",
  nix-flatpak,
  ...
}: let
  nixpkgsConfig = {
    allowUnfree = false;
    allowUnfreePredicate = pkg:
      builtins.elem (nixpkgs.lib.getName pkg) [
        "1password"
        "1password-cli"
        "discord"
        "obsidian"
        "steam"
        "steam-unwrapped"
        "libvgm"
        "vscode"
      ];
    permittedInsecurePackages = [
      "python3.12-django-3.1.14"
    ];
  };
  unstable = import nixpkgs-unstable {
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
in
  systemFunc {
    system = system;
    specialArgs = {inherit unstable;};
    modules = [
      {
        imports =
          [
            home-manager.nixosModules.home-manager
            nix-flatpak.nixosModules.nix-flatpak
          ]
          ++ nixos-imports;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {inherit unstable;};
        nixpkgs.config = nixpkgsConfig;
        nixpkgs.overlays = [
          (import ./overlays/brave.nix)
          (import ./overlays/jetbrains-pin.nix)
        ];
        home-manager.users.aurelia = {
          imports =
            [
              #nix-flatpak.homeManagerModules.nix-flatpak
            ]
            ++ home-manager-imports;
          home.username = home-manager-username;
          home.homeDirectory = home-manager-homedir;
        };
      }
    ];
  }
