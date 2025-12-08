{
  sshKeys.aurelia = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmjGIsSO9jE85xNPzzp0AWfOSXVL4qQ3cuXeKCvxe+q"
  ];
  tailscale.ip = {
    sunhome = "100.84.223.80";
    fool = "100.119.163.58";
  };
  browserPolicy = import ./browserpolicy.nix;
}
