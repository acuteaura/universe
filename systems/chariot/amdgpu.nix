{pkgs, ...}: {
  services.xserver.videoDrivers = ["amdgpu"];

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # For 32 bit applications
    extraPackages = with pkgs; [
      libvdpau-va-gl
      rocmPackages.clr.icd
      amdvlk
      mesa
    ];
  };

  environment.systemPackages = with pkgs; [
    radeontop
  ];
}
