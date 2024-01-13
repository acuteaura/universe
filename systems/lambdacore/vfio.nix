# based upon work by astrid yu
# https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/
{ pkgs, lib, config, ... }: 
{
  options.vfio.enable = with lib;
    mkEnableOption "Configure the machine for VFIO";

  config = {
    specialisation."VFIO".configuration = {
      system.nixos.tags = [ "with-vfio" ];
      vfio.enable = true;
    };

    # this exact order is important so that vfio_pci can claim NVIDIA devices
    # if the VFIO specialization is enabled
    boot = {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        # merged in linux 6.2
        #"vfio_virqfd"

        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
      kernelParams = [
        # enable IOMMU
        "amd_iommu=on"
      ] ++ lib.optional config.vfio.enable
        # isolate the GPU
        ("vfio-pci.ids=" + lib.concatStringsSep "," [ "10de:24dd" "10de:228b" ]);
    };
  };
}
