{ config, pkgs, unstable, ... }:
{
  home.packages = with pkgs; [
    act
    azure-cli
    bun
    flyctl
    gh
    gnumake
    go
    hcloud
    nixpkgs-fmt
    opentofu
    sqlite
    unstable.python3

    unstable.eslint
    unstable.vue-language-server
    unstable.tailwindcss-language-server
    unstable.yaml-language-server
    unstable.typescript-language-server
  ];
}
