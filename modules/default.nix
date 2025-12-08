{...}: {
  imports = [
    ./amdgpu.nix
    ./apps.nix
    ./base.nix
    ./boot.nix
    ./comfyui-container.nix
    ./desktop-base.nix
    ./desktop-gnome.nix
    ./desktop-niri.nix
    ./desktop-plasma.nix
    ./emulators.nix
    ./games.nix
    ./invoke-container.nix
    ./kernel.nix
    ./libvirt.nix
    ./ollama-container.nix
    ./sillytavern-container.nix
    ./sunshine
    ./tailscale-sidecar.nix
    ./wine.nix
    ./zed-quicksand.nix
  ];
}
