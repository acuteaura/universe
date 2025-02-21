{ config, pkgs, ... }:
{
  home.packages = with pkgs; [

  ] ++ lib.optionals (pkgs.stdenv.isLinux) [
    distrobox
    docker-machine-kvm2
  ] ++ lib.optionals (pkgs.stdenv.isDarwin) [
    colima
    lima
    docker-client
    docker-buildx
    docker-credential-helpers
  ];
}
