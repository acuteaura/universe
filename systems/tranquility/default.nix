{ config, pkgs, hashedPassword, ... }:
{
    imports = [
        ./tranquility.nix
        ./tlp.nix
        ./nvidia.nix
    ];
}