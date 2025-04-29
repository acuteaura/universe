{pkgs, ...}: {
  home.packages = with pkgs; [
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
