{
  getName,
  extraOverlays ? [],
}: {
  nixpkgs.config = {
    allowUnfree = false;
    allowUnfreePredicate = pkg:
      builtins.elem (getName pkg) [
        # "weird" free
        "graphite"

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
        "spotify"
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
    import ./overlays
    ++ extraOverlays;
}
