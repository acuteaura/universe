{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    python3
    python3Packages.virtualenv
    python3Packages.kokoro
    whisper-cpp
    uv
    sox
  ];
}
