{
  pkgs,
  lib,
  config,
  ...
}: {
  options.universe.games = {
    enable = lib.mkEnableOption "Enable gaming applications";
    fuckUpMyKernelForSteamVR = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Patch security out of the kernel. Do not enter into Valhalla.
      '';
    };
  };

  config = lib.mkIf config.universe.games.enable {
    universe.amdgpu.patches = lib.mkIf config.universe.games.fuckUpMyKernelForSteamVR [
      (pkgs.fetchpatch2 {
        url = "https://github.com/Frogging-Family/community-patches/raw/a6a468420c0df18d51342ac6864ecd3f99f7011e/linux61-tkg/cap_sys_nice_begone.mypatch";
        hash = "sha256-1wUIeBrUfmRSADH963Ax/kXgm9x7ea6K6hQ+bStniIY=";
      })
    ];

    environment.systemPackages = with pkgs; [
      mangohud
      heroic
      steamtinkerlaunch
      lsfg-vk
      lsfg-vk-ui
    ];
    system.userActivationScripts.steamtinkerlaunchCompatAdd.text = ''
      ${pkgs.steamtinkerlaunch}/bin/steamtinkerlaunch compat add
    '';
    hardware.xpadneo.enable = lib.mkDefault false;
    hardware.steam-hardware.enable = lib.mkDefault true;
    programs.gamemode.enable = lib.mkDefault true;

    environment.sessionVariables = {
      MESA_SHADER_CACHE_MAX_SIZE = "10G";
    };

    programs.steam = {
      enable = lib.mkDefault true;
      protontricks.enable = lib.mkDefault true;
      localNetworkGameTransfers.openFirewall = lib.mkDefault true;
      gamescopeSession = {
        enable = lib.mkDefault true;
        args = lib.mkDefault [
          "--expose-wayland"
          "-e" # Enable steam integration
        ];
      };
      package = pkgs.steam.override {
        extraPkgs = pkgs':
          with pkgs'; [
            freetype
            fontconfig
          ];
      };
    };
  };
}
