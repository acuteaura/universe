{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    age-plugin-yubikey
    nmap
    tcpdump
    tshark
  ] ++ lib.optionals (!pkgs.stdenv.isDarwin) [

  ];
}
