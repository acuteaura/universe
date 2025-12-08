{
  pkgs,
  lib,
  ...
}: {
  nix.settings.system-features = ["benchmark" "big-parallel" "kvm" "nixos-test" "gccarch-znver4"];

  # Selectively optimize gaming-critical packages with Zen4
  nixpkgs.overlays = [
    (final: prev: let
      # Helper function to rebuild a package with Zen4 optimizations
      withZen4 = pkg:
        pkg.override {
          stdenv = final.stdenvAdapters.withCFlags ["-march=znver4" "-mtune=znver4"] final.stdenv;
        };
    in {
      # Kernel
      linuxPackages_cachyos = withZen4 prev.linuxPackages_cachyos;
      linuxPackages_6_12 = withZen4 prev.linuxPackages_6_12;
      zfs_cachyos = withZen4 prev.zfs_cachyos;
      zfs = withZen4 prev.zfs;

      # Graphics stack - critical for gaming performance
      mesa = withZen4 prev.mesa;

      # Wine/Proton compatibility layer - heavily used in gaming
      wine = withZen4 prev.wine;
      wine64 = withZen4 prev.wine64;
      wine-staging = withZen4 prev.wine-staging;

      # DirectX to Vulkan translation layers
      dxvk = withZen4 prev.dxvk;
      vkd3d-proton = withZen4 prev.vkd3d-proton;

      # Media libraries - for video decoding and streaming
      ffmpeg = withZen4 prev.ffmpeg;

      # SDL - common game framework
      SDL2 = withZen4 prev.SDL2;

      # Vulkan components
      vulkan-loader = withZen4 prev.vulkan-loader;
    })
  ];
}
