{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    python3
    python3Packages.virtualenv
    python3Packages.kokoro
    whisper-cpp
    uv
    sox
  ];

  # Enable nix-ld for running dynamic executables
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    portaudio
  ];
}
