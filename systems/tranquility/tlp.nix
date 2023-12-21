{ config, lib, pkgs, modulesPath, ... }:
{
  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "default";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 80;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      CPU_HWP_DYN_BOOST_ON_AC=0;
      CPU_HWP_DYN_BOOST_ON_BAT=0;

      #START_CHARGE_THRESH_BAT0 = 75;
      #STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
}
