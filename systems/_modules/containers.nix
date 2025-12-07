{pkgs, ...}: {
  virtualisation = {
    containers.enable = true;
    docker.enable = false;
    podman = {
      enable = true;
      dockerSocket.enable = true;
      dockerCompat = true;
    };
  };

  environment.systemPackages = with pkgs; [
    docker-client
  ];
}
