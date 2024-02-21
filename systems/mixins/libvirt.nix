{ pkgs, config, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    package = pkgs.libvirt;
    onShutdown = "shutdown";
    onBoot = "ignore";
    qemu = {
      swtpm.enable = true;
      ovmf.enable = true;
      ovmf.packages = [ pkgs.OVMFFull.fd ];
      package = pkgs.qemu;
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;

  environment.etc = {
    "ovmf/edk2-x86_64-secure-code.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
    };

    "ovmf/edk2-i386-vars.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-i386-vars.fd";
    };
  };

  environment.systemPackages = with pkgs; [
    virtiofsd
  ];
}
