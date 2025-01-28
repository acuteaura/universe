{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    driSupport32Bit = true; # For 32 bit applications
    extraPackages = with pkgs; [
      libvdpau-va-gl
      rocmPackages.clr.icd
    ];
  };

  environment.systemPackages = with pkgs; [
    radeontop
  ];
}
