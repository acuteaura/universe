{constants, ...}: {
  universe.comfyui-container = {
    enable = true;
    rdnaGeneration = "rdna3";
    useAPU = false;
    listenAddress = constants.tailscale.ip.fool;
  };

  universe.invokeai-container = {
    enable = true;
    rdnaGeneration = "rdna3";
    useAPU = false;
    listenAddress = constants.tailscale.ip.fool;
    dataDir = "/media/invoke";
    extraVolumes = ["/media/tensors:/media/tensors"];
  };
}
