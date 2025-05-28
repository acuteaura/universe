{pkgs, ...}: {
  users.groups.aurelia = {
    name = "aurelia";
    gid = 1000;
  };
  users.users.aurelia = {
    isNormalUser = true;
    group = "aurelia";
    extraGroups = ["wheel" "docker" "systemd-journal" "libvirtd"];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmjGIsSO9jE85xNPzzp0AWfOSXVL4qQ3cuXeKCvxe+q"];
    shell = pkgs.fish;
  };
  nix.settings.trusted-users = ["aurelia"];
  programs._1password-gui.polkitPolicyOwners = ["aurelia"];
}
