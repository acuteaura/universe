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
        "claude-code"
        "discord"
        "libvgm"
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
        "idea"
        "idea-with-plugins"
      ];
    allowInsecurePredicate = pkg:
      builtins.elem (getName pkg) [
      ];
  };
  nixpkgs.overlays =
    import ./overlays
    ++ extraOverlays;
}
