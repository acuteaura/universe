{
  extraSpecialArgs,
  home-manager-username ? "aurelia",
  home-manager-homedir ? "/home/aurelia",
  home-manager-imports,
  nixpkgsConfig,
  nix-flatpak ? null,
}: {
  imports = [nixpkgsConfig];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = extraSpecialArgs;
  home-manager.backupFileExtension = "hmbak";
  home-manager.users."${home-manager-username}" = import ./basehmuser.nix {inherit home-manager-username home-manager-homedir home-manager-imports;};
}
