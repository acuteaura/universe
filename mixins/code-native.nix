{ config, pkgs, unstable, ... }:
{
  environment.systemPackages = with unstable; [
    (vscode-with-extensions.override {
      inherit vscode;
      vscodeExtensions = with vscode-extensions; [
        golang.go
        mvllow.rose-pine
        bbenoist.nix
        ms-vscode-remote.remote-ssh
        editorconfig.editorconfig
        tamasfe.even-better-toml
        github.codespaces
        eamodio.gitlens
        github.copilot
        github.copilot-chat
        ms-kubernetes-tools.vscode-kubernetes-tools
        yzhang.markdown-all-in-one
        vscode-icons-team.vscode-icons
      ];
    })
  ];
}
