{ pkgs, unstable, ... }:
{
  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;

    package = unstable.podman;
    dockerSocket.enable = true;
  };

  environment.systemPackages = with pkgs; [
    docker-client
  ];
}
