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
    tools = lib.mkEnableOption "Install AMD GPU tools (radeontop, amdgpu_top, lact)";
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

    environment.systemPackages = lib.mkIf cfg.tools (with pkgs; [
      radeontop
      amdgpu_top
      lact
    ]);

    systemd.packages = lib.mkIf cfg.tools (with pkgs; [lact]);
    systemd.services.lactd.wantedBy = lib.mkIf cfg.tools ["multi-user.target"];

    boot.extraModulePackages = lib.mkIf (cfg.patches != []) [
      (pkgs.callPackage ./amdgpu-package.nix {
        inherit (config.boot.kernelPackages) kernel;
        inherit (cfg) patches;
      })
    ];
  };
}
