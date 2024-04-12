{ pkgs, ... }:
{
  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;

    package = pkgs.podman;
    dockerSocket.enable = true;
  };

  environment.systemPackages = with pkgs; [
    docker-client
  ];
}
