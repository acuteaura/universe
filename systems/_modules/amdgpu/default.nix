{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.universe.amdgpu;
in {
  options.universe.amdgpu = {
    enable = lib.mkEnableOption "Enable AMD GPU support";
    patches = lib.mkOption {
      type = with lib.types; listOf path;
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = ["amdgpu"];

    hardware.graphics = {
      enable = true;
      enable32Bit = true; # For 32 bit applications
      extraPackages = with pkgs; [
        libvdpau-va-gl
        rocmPackages.clr.icd
      ];
    };

    #environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";

    environment.systemPackages = with pkgs; [
      radeontop
      amdgpu_top
      lact
    ];

    systemd.packages = with pkgs; [lact];
    systemd.services.lactd.wantedBy = ["multi-user.target"];

    boot.extraModulePackages = [
      (pkgs.callPackage ./../../../packages/amdgpu.nix {
        inherit (config.boot.kernelPackages) kernel;
        inherit (cfg) patches;
      })
    ];
  };
}
