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
    go
    hcloud
    llvm
    nixpkgs-fmt
    opentofu
    rustup
    sqlite
  ];
}
