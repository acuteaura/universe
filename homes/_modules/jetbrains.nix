{...}: let
  # https://github.com/NixOS/nixpkgs/issues/400317
  jbpkgs =
    import
    (builtins.fetchTree {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      rev = "2c8d3f48d33929642c1c12cd243df4cc7d2ce434";
    })
    {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
    };
in {
  home.packages = with jbpkgs; [
    (jetbrains.plugins.addPlugins jetbrains.idea-ultimate ["github-copilot" "go" "rust"])
  ];
}
