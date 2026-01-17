{ ... }:
{
  jovian = {
    steam = {
      enable = true;
      autoStart = false;
      updater.splash = "jovian";
      user = "aurelia";
    };
    decky-loader.enable = true;
    devices = {
      steamdeck.enable = false;
    };
    hardware.has.amd.gpu = false;
    steamos = {
      enableAutoMountUdevRules = false;
    };
  };
  programs.steam.gamescopeSession.enable = false;
}
