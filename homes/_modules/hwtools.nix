{
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
    ]
    ++ lib.optionals (pkgs.stdenv.isLinux) [
      dmidecode
      pciutils
      powertop
      s-tui
      stress
      usbutils
    ];
}
