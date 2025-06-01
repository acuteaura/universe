{
  pkgs,
  unstable,
  nixos-imports ? [],
  home-manager,
  home-manager-imports ? [],
  home-manager-username ? "aurelia",
  home-manager-homedir ? "/home/aurelia",
  ...
}: {
  imports = [home-manager.nixosModules.home-manager] ++ nixos-imports;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {inherit unstable;};
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "python3.11-django-3.1.14"
      "python3.12-django-3.1.14"
    ];
  };
  nixpkgs.overlays = [
    (import ./overlays/brave.nix)
    (import ./overlays/jetbrains-pin.nix)
  ];
  home-manager.users.aurelia = {
    imports = home-manager-imports;
    home.username = home-manager-username;
    home.homeDirectory = home-manager-homedir;
  };
}
