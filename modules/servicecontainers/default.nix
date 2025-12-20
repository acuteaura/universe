{
  lib,
  config,
  ...
}: let
  cfg = config.universe.serviceContainers;
in {
  imports = [
    ./comfyui.nix
    ./invoke.nix
    ./koboldcpp.nix
    ./ollama.nix
    ./sillytavern.nix
  ];
}
