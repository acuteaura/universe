{ config, pkgs, unstable, ... }:
{
  home.packages = with pkgs; [
    act
    azure-cli
    bun
    devbox
    flyctl
    flyctl
    gh
    gnumake
    go
    hcloud
    nixpkgs-fmt
    opentofu
    rustup
    sqlite

    unstable.eslint
    unstable.vue-language-server
    unstable.tailwindcss-language-server
    unstable.yaml-language-server
    unstable.typescript-language-server
  ];
}
