{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    act
    bun
    clang
    devbox
    flyctl
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
