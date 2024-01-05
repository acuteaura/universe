# based upon work by astrid yu
# https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/
{ pkgs, lib, config, ... }: {
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
        "vfio_virqfd"

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
        ("vfio-pci.ids=" + lib.concatStringsSep "," ["10de:24dd" "10de:228b"]);
    };

    hardware.opengl.enable = true;

    virtualisation.libvirtd = {
      enable = true;
      onShutdown = "shutdown";
      onBoot = "ignore";
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    virtualisation.spiceUSBRedirection.enable = true;

    # fake battery for 3070 Mobile, otherwise upset about lack of virtual 8-pin power
    # https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF#%22Error_43:_Driver_failed_to_load%22_with_mobile_(Optimus/max-q)_nvidia_GPUs
    environment.etc = {
      "libvirt/SSDT1.dat" = {
        source = ./SSDT1.dat;
        user = "aurelia";
        group = "qemu-libvirtd";
        mode = "0660";
      };
    };

    # looking glass
    environment.systemPackages = with pkgs; [
      looking-glass-client
    ];
    systemd.tmpfiles.rules = [
      "f /dev/shm/looking-glass 0660 aurelia qemu-libvirtd -"
    ];
  };
}