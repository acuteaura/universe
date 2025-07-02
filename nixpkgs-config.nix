{nixpkgs}: {
  nixpkgs.config = {
    allowUnfree = false;
    allowUnfreePredicate = pkg:
      builtins.elem (nixpkgs.lib.getName pkg) [
        "1password"
        "1password-cli"
        "discord"
        "obsidian"
        "steam"
        "steam-unwrapped"
        "libvgm"
        "vscode"
        "rose-pine-kvantum"
        "idea-ultimate-with-plugins"
        "idea-ultimate"
        "steam-jupiter-unwrapped"
        "steamdeck-hw-theme"
        "via"
      ];
    permittedInsecurePackages = [
      "python3.12-django-3.1.14"
      "python3.13-django-3.1.14"
      "freeimage-3.18.0-unstable-2024-04-18"
    ];
  };
  nixpkgs.overlays = [
    (import ./overlays/brave.nix)
    (import ./overlays/hhd.nix)
    (import ./overlays/fix-python3.nix)
  ];
}
