{ config, pkgs, hashedPassword, ... }:
{
  imports = [
    ../mixins/base.nix
    ../mixins/code-native.nix
    ../mixins/desktop-base.nix
    ../mixins/desktop-plasma.nix
    ../mixins/work.nix
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
