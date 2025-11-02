{
  home-manager-username ? "aurelia",
  home-manager-homedir ? "/home/aurelia",
  home-manager-imports,
}: {
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  imports = home-manager-imports;
  home.username = home-manager-username;
  home.homeDirectory = home-manager-homedir;
}
