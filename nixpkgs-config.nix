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
        "aptakube"
        "claude-code"
        "discord"
        "idea-ultimate"
        "idea-ultimate-with-plugins"
        "insync"
        "libvgm"
        "lmstudio"
        "obsidian"
        "rose-pine-kvantum"
        "steam"
        "steam-jupiter-unwrapped"
        "steam-unwrapped"
        "steamdeck-hw-theme"
        "unrar"
        "via"
        "vital"
        "vscode"
        "reaper"
      ];
    allowInsecurePredicate = pkg:
      builtins.elem (getName pkg) [
      ];
  };
  nixpkgs.overlays =
    [
      (import ./overlays/appwrap.nix)
      (import ./overlays/brave.nix)
      (import ./overlays/claude-sandboxed.nix)
      (import ./overlays/fix-python3.nix)
      (import ./overlays/pin-versions.nix)
    ]
    ++ extraOverlays;
}
