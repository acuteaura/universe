{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.universe.libvirt;
in {
  options.universe.libvirt = {
    enable = lib.mkEnableOption "Libvirt virtualization support";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      package = pkgs.libvirt;
      onShutdown = "shutdown";
      onBoot = "ignore";
      qemu = {
        swtpm.enable = true;
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
      virt-manager
      virtiofsd
    ];

    environment.sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";

    networking.firewall.trustedInterfaces = ["virbr0"];
  };
}
