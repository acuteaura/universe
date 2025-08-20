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
        "idea-ultimate"
        "idea-ultimate-with-plugins"
        "insync"
        "libvgm"
        "obsidian"
        "rose-pine-kvantum"
        "steam"
        "steam-jupiter-unwrapped"
        "steam-unwrapped"
        "steamdeck-hw-theme"
        "via"
        "vscode"
        "unrar"
      ];
    allowInsecurePredicate = pkg:
      builtins.elem (getName pkg) [
        "django"
        "freeimage"
      ];
  };
  nixpkgs.overlays =
    [
      (import ./overlays/brave.nix)
      (import ./overlays/fix-python3.nix)
      (import ./overlays/pin-versions.nix)
    ]
    ++ extraOverlays;
}
