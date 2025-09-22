{pkgs, ...}: {
  home.packages = with pkgs; [
    btop
    curl
    dig
    ffmpeg
    file
    fish
    git
    gnugrep
    gnumake
    gnupg
    gnused
    htop
    llvm
    openssl
    sshfs
    wget
    cryptsetup
    usbutils
  ];
}
