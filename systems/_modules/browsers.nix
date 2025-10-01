{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    brave
    firefox
    librewolf
  ];

  environment.etc."brave/policies/managed/anti-eich-aktion.json" = {
    text = ''
      {
        "BraveRewardsDisabled": true,
        "BraveWalletDisabled": true,
        "BraveVPNDisabled": true,
        "BraveAIChatEnabled": false,
        "TorDisabled": true,
        "BraveNewsDisabled": true,
        "BraveTalkDisabled": true,
        "BraveWaybackMachineEnabled": false,
        "BraveP3AEnabled": false,
        "BraveStatsPingEnabled": false,
        "BraveWebDiscoveryEnabled": false,
        "BravePlaylistEnabled": false,
        "ExtensionInstallForcelist": [
          "aeblfdkhhhdcdjpifhhbdiojplfjncoa",
          "cdglnehniifkbagbbombnjghhcihifij"
        ]
      }
    '';
  };

  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      librewolf
      vivaldi-bin
    '';
    mode = "0755";
  };
}
