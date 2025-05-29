{pkgs, ...}: {
  home.packages = with pkgs; [
    azure-cli
    eslint
    vue-language-server
    tailwindcss-language-server
    yaml-language-server
    typescript-language-server
  ];
}
