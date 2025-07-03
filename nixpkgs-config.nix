{
  getName,
  extraOverlays ? [],
}: {
  nixpkgs.config = {
    allowUnfree = false;
    allowUnfreePredicate = pkg:
      builtins.elem (getName pkg) [
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
    allowInsecurePredicate = pkg:
      builtins.elem (getName pkg) [
        "django"
        "freeimage"
      ];
    permittedInsecurePackages = [
      "python3.12-django-3.1.14"
    ];
  };
  nixpkgs.overlays =
    [
      (import ./overlays/brave.nix)
      (import ./overlays/hhd.nix)
      (import ./overlays/fix-python3.nix)
    ]
    ++ extraOverlays;
}
