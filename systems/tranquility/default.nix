{ config, pkgs, hashedPassword, ... }:
{
  imports = [
    ../_mixins/base.nix
    ../_mixins/code-native.nix
    ../_mixins/desktop-base.nix
    ../_mixins/desktop-plasma.nix
    ../_mixins/work.nix
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
