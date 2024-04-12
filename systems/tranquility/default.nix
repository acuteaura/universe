{ config, pkgs, hashedPassword, ... }:
{
  imports = [
    ../_modules/base.nix
    ../_modules/code-native.nix
    ../_modules/desktop-base.nix
    ../_modules/desktop-plasma.nix
    ../_modules/work.nix
    ./hardware.nix
    ./tlp.nix
    ./gpu.nix
  ];

  # locally installed packages
  environment.systemPackages = with pkgs; [

  ];

  services.xserver.displayManager.defaultSession = "plasmawayland";
  services.xserver.displayManager.sddm.enableHidpi = true;
}
