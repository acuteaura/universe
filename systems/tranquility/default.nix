{ config, pkgs, hashedPassword, ... }:
{
    imports = [
        ./tranquility.nix
        ./tlp.nix
        ./gpu.nix
    ];
}
