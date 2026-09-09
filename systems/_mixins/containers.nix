{pkgs, ...}: {
  virtualisation = {
    containers.enable = true;
    docker.rootless = {
      enable = false;
      setSocketVariable = true;
    };
    podman = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    docker-client
  ];
}
