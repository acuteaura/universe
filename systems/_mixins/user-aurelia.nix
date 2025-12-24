{
  pkgs,
  constants,
  ...
}: {
  users.groups.aurelia = {
    name = "aurelia";
    gid = 1000;
  };
  users.users.aurelia = {
    isNormalUser = true;
    group = "aurelia";
    extraGroups = [
      "wheel"
      "docker"
      "podman"
      "systemd-journal"
      "libvirtd"
      "scanner"
      "lp"
      "kvm"
      "input"
    ];
    openssh.authorizedKeys.keys = constants.sshKeys.aurelia;
    shell = pkgs.fish;
  };
  nix.settings.trusted-users = ["aurelia"];
  programs._1password-gui.polkitPolicyOwners = ["aurelia"];
}
