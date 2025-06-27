{
  nixpkgs,
  nixpkgs-unstable,
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
        "rose-pine-kvantum"
        "idea-ultimate-with-plugins"
        "idea-ultimate"
        "steam-jupiter-unwrapped"
        "steamdeck-hw-theme"
      ];
    permittedInsecurePackages = [
      "python3.12-django-3.1.14"
      "python3.13-django-3.1.14"
      "freeimage-3.18.0-unstable-2024-04-18"
    ];
  };
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
        homeManagerModule
        nix-flatpak.nixosModules.nix-flatpak
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit unstable;};
          nixpkgs.config = nixpkgsConfig;
          nixpkgs.overlays = [
            (import ./overlays/brave.nix)
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
      ]
      ++ nixos-imports;
  }
