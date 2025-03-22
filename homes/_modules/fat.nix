{
  pkgs,
  unstable,
  ...
}: {
  home.packages = with pkgs; [
    azure-cli
    unstable.eslint
    unstable.vue-language-server
    unstable.tailwindcss-language-server
    unstable.yaml-language-server
    unstable.typescript-language-server
  ];
}
