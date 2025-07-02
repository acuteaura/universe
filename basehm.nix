{
  extraSpecialArgs,
  home-manager-username ? "aurelia",
  home-manager-homedir ? "/home/aurelia",
  home-manager-imports,
  nixpkgsConfig,
}: {
  imports = [nixpkgsConfig];
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = extraSpecialArgs;
  home-manager.backupFileExtension = "hmbak";
  home-manager.users."${home-manager-username}" = {
    imports = home-manager-imports;
    home.username = home-manager-username;
    home.homeDirectory = home-manager-homedir;
  };
}
