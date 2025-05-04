let
  gpuIDs = [
    "1002:164e" # VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Raphael
    "1002:1640" # Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Rembrandt Radeon High Definition Audio Controller
  ];
in
  {
    pkgs,
    lib,
    config,
    ...
  }: {
    options.vfio.enable = with lib;
      mkEnableOption "Configure the machine for VFIO";

    config = let
      cfg = config.vfio;
    in {
      boot = {
        initrd.kernelModules = [
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"

          "amdgpu"
        ];

        kernelParams =
          [
            # enable IOMMU
            "amd_iommu=on"
          ]
          ++ lib.optional cfg.enable
          # isolate the GPU
          ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);
      };

      environment.systemPackages = [pkgs.looking-glass-client];
    };
  }
