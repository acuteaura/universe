{pkgs, ...}: let
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
  services.globalprotect = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    globalprotect-openconnect
  ] ++ (with jbpkgs; [
    (jetbrains.plugins.addPlugins jetbrains.idea-ultimate ["github-copilot" "go" "rust"])
  ]);
}
