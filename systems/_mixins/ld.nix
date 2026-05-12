{pkgs, ...}: {
  # Enable nix-ld for running dynamic executables
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    portaudio
  ];
}
