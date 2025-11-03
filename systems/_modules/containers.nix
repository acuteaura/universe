_: {
  virtualisation = {
    containers.enable = true;
    docker = {
      enable = true;
      rootless.enable = true;
    };
    podman = {
      enable = true;
    };
  };
}
