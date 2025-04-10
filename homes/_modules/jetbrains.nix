{unstable, ...}: {
  home.packages = with unstable; [
    (jetbrains.plugins.addPlugins jetbrains.idea-ultimate ["github-copilot" "go" "rust"])
  ];
}
