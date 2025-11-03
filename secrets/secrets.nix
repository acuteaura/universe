let
  constants = import ./constants.nix;

  keysAurelia = constants.sshKeys.aurelia;
in {
  "bootstrap.age".publicKeys = keysAurelia;
}
