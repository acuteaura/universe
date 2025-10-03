{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    brave
    firefox
    librewolf
  ];

  environment.etc."brave/policies/managed/brave.json".text =
    builtins.toJSON (import ./browserpolicy.nix).brave;

  environment.etc."opt/edge/policies/managed/edge.json".text =
    builtins.toJSON (import ./browserpolicy.nix).edge;

  environment.etc."opt/chrome/policies/managed/chrome.json".text =
    builtins.toJSON (import ./browserpolicy.nix).chrome;

  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      librewolf
      vivaldi-bin
    '';
    mode = "0755";
  };
}
