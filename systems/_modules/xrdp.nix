{pkgs, ...}: {
  services.xrdp = {
    enable = true;
    defaultWindowManager = "${pkgs.writeShellScript "xrdp-session-script" ''
      systemd-inhibit --mode=block --what="sleep:idle:handle-lid-switch" --why=xrdp startplasma-x11
    ''}";
    openFirewall = true;
    audio.enable = true;
    #sslKey = "/etc/chariot.atlas-ide.ts.net.key";
    #sslCert = "/etc/chariot.atlas-ide.ts.net.crt";
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel"))
      {
        return polkit.Result.YES;
      }
    });
  '';
}
