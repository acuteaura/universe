{modulesPath, ...}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];
  boot.loader.systemd-boot.enable = true;

  boot.kernelParams = [ "console=tty" ];
  boot.initrd.kernelModules = [ "virtio_gpu" ];

  fileSystems."/boot" = { device = "/dev/disk/by-uuid/7763-8830"; fsType = "vfat"; };
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };

}
