{pkgs, ...}: {
  home.packages = with pkgs; [
    azure-cli
    act
    bun
    clang
    devbox
    fly
    gh
    gnumake
    gom
    hcloud
    llvm
    nixpkgs-fmt
    opentofu
    rustup
    sqlite
    pgo-client
    nodejs_22
  ];
}
