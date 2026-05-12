{pkgs, ...}: {
  # Inhibit sleep/idle while on AC power; releases lock when on battery
  systemd.services.ac-sleep-inhibit = {
    description = "Inhibit sleep while on AC power";
    wantedBy = ["multi-user.target"];
    unitConfig.ConditionACPower = "true";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.systemd}/bin/systemd-inhibit --mode=block --what=sleep:idle --why='AC power - headless mode' ${pkgs.coreutils}/bin/sleep infinity";
    };
  };

  # Re-evaluate the inhibitor whenever AC adapter status changes
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ATTR{type}=="Mains", RUN+="${pkgs.systemd}/bin/systemctl restart ac-sleep-inhibit.service"
  '';

  # Ignore lid switch regardless of power source (headless)
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";
  services.logind.lidSwitchDocked = "ignore";
}
