{pkgs, ...}: {
  services.xserver.videoDrivers = ["amdgpu"];

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # For 32 bit applications
    extraPackages = with pkgs; [
      libvdpau-va-gl
      rocmPackages.clr.icd
    ];
  };

  environment.systemPackages = with pkgs; [
    radeontop
    amdgpu_top
    lact
  ];

  systemd.packages = with pkgs; [lact];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  boot.kernelParams = ["amdgpu.ppfeaturemask=0xffffffff"];
}
