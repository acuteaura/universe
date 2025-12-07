_: {
  imports = [
    ./amdgpu
    ./apps.nix
    ./base.nix
    ./boot.nix
    ./desktop-base.nix
    ./desktop-gnome.nix
    ./desktop-niri.nix
    ./desktop-plasma.nix
    ./emulators.nix
    ./games.nix
    ./kernel.nix
    ./libvirt.nix
    ./sunshine
    ./wine.nix

    # slop testing ground
    ./comfyui-container.nix
    ./invoke-container.nix
  ];
}
