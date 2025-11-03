{pkgs, ...}: let
  const = import ../../constants.nix;
  # this line prevents hanging on network split
  automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
in {
  environment.systemPackages = [pkgs.cifs-utils];
  fileSystems."/media/smb/media" = {
    device = "//${const.tailscaleIP.sunhome}/media";
    fsType = "cifs";
    options = ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=1000"];
  };
  fileSystems."/media/smb/scratch" = {
    device = "//${const.tailscaleIP.sunhome}/aurelia";
    fsType = "cifs";
    options = ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=1000"];
  };
  fileSystems."/media/taildrive" = {
    device = "http://100.100.100.100:808";
    fsType = "davfs";
    options = ["${automount_opts},uid=1000,gid=1000"];
  };
}
