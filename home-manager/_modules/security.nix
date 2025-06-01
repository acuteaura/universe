{pkgs, ...}: {
  home.packages = with pkgs;
    [
      age-plugin-yubikey
      nmap
      semgrep
      tcpdump
      tshark
    ]
    ++ lib.optionals (!pkgs.stdenv.isDarwin) [
    ];
}
