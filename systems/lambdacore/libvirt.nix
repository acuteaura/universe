{ pkgs, config, ... }:
{
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

  environment.etc = {
    "ovmf/edk2-x86_64-secure-code.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
    };

    "ovmf/edk2-i386-vars.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-i386-vars.fd";
    };
  };

  # looking glass
  environment.systemPackages = with pkgs; [
    looking-glass-client
    virtiofsd
  ];
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 aurelia qemu-libvirtd -"
  ];
}
