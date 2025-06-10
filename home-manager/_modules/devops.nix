{pkgs, ...}: {
  home.packages = with pkgs; [
    act
    azure-cli
    bun
    clang
    devbox
    fly
    gh
    gitversion
    gnumake
    gom
    hcloud
    llvm
    nixpkgs-fmt
    nodejs_22
    nufmt
    nushell
    nushellPlugins.semver
    opentofu
    pgo-client
    rustup
    sqlite
  ];
}
