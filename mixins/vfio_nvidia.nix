{ pkgs, lib, config, ... }: {
  options.vfio.enable = with lib;
    mkEnableOption "Configure the machine for VFIO";
  options.vfio.gpuIDs = with lib;
    mkOption {
      type = with types; listOf string;
      default = [ ];
    };

  config =
    let cfg = config.vfio;
    in {
      boot = {
        initrd.kernelModules = [ ] ++ lib.optional cfg.enable [
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"
          "vfio_virqfd"

          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ];

        kernelParams = [ ] ++ lib.optional cfg.enable [
          # enable IOMMU
          "amd_iommu=on"

          # isolate the GPU
          ("vfio-pci.ids=" + lib.concatStringsSep "," cfg.gpuIDs)
        ];

        hardware.opengl.enable = true;
        virtualisation.spiceUSBRedirection.enable = true;
      };
    };
}