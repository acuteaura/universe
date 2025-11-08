_: {
  imports = [
    ./amdgpu.nix
    ./base.nix
    ./desktop-base.nix
    ./desktop-plasma.nix
    ./desktop-niri.nix
    ./desktop-gnome.nix

    ./sunshine

    ./amdgpu.nix
    ./apps-flatpak.nix
    ./apps.nix
    ./emulators.nix
    ./games.nix
    ./kernel.nix
    ./libvirt.nix
    ./wine.nix
  ];
}
