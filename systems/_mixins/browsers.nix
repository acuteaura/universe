{
  pkgs,
  constants,
  ...
}: {
  environment.systemPackages = with pkgs; [
    brave
    firefox
    librewolf
    chromium
    zen
  ];

  environment.etc."brave/policies/managed/brave.json".text =
    builtins.toJSON constants.browserPolicy.brave;

  environment.etc."opt/edge/policies/managed/edge.json".text =
    builtins.toJSON constants.browserPolicy.edge;

  environment.etc."opt/chrome/policies/managed/chrome.json".text =
    builtins.toJSON constants.browserPolicy.chrome;

  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      zen
    '';
    mode = "0755";
  };
}
