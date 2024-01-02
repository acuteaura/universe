{ config, pkgs, unstable, ... }:
{
  services.globalprotect = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    teams-for-linux
    globalprotect-openconnect
  ];
}
