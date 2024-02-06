{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.opengl = {
    enable = true;
    driSupport = true; # This is already enabled by default
    driSupport32Bit = true; # For 32 bit applications
    extraPackages = with pkgs; [
      libvdpau-va-gl
    ];
  };

  environment.systemPackages = with pkgs; [
    radeontop
  ];
}
