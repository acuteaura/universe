{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (jetbrains.plugins.addPlugins jetbrains.idea-ultimate ["github-copilot" "go" "rust"])
  ];
}
