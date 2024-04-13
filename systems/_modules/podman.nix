{ pkgs, ... }:
{
  virtualisation.containers.enable = true;
virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
  enable = true;
  setSocketVariable = true;
};
}
