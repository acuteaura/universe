{ config, lib, pkgs, modulesPath, ... }:
{
  options.nvidia-sync.enable = lib.mkEnableOption "Enable NVIDIA prime sync mode";

  config = {
    specialisation."NVIDIA-SYNC".configuration = {
      system.nixos.tags = [ "with-nvidia-sync" ];
      nvidia-sync.enable = true;
    };

    services.xserver.videoDrivers = [ "nvidia" "modeset" ];

    hardware.nvidia = {
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = ! config.nvidia-sync.enable;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = ! config.nvidia-sync.enable;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of 
      # supported GPUs is at: 
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = {
        amdgpuBusId = "PCI:6:0:0";
        nvidiaBusId = "PCI:1:0:0";
      } // lib.optionalAttrs config.nvidia-sync.enable {
        sync.enable = true;
      } // lib.optionalAttrs (!config.nvidia-sync.enable) {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };
  };
}
