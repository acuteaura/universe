{modulesPath, ...}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];
  boot.loader.systemd-boot.enable = true;

  boot.kernelParams = ["console=tty"];
  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront"];
  boot.initrd.kernelModules = ["nvme" "virtio_gpu"];

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7763-8830";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7e1b5c37-1536-47c9-b5a0-456340d2327f";
    fsType = "ext4";
  };
}
