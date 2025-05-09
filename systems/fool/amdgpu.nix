{pkgs, ...}: let
  setGPUPerfScript = pkgs.writeScript "set-gpu-performance.fish" ''
    #!${pkgs.fish}/bin/fish

    if test (id -u) -ne 0
      echo "This script must be run as root."
      exit 1
    end

    argparse "level=" -- $argv
    or begin
      echo "Usage: set-gpu-performance --level <auto|low|high>"
      exit 1
    end

    set level $_flag_level
    if not contains $level auto low high
      echo "Invalid level: $level"
      echo "Supported levels: auto, low, high"
      exit 1
    end

    echo $level > /sys/class/drm/card1/device/power_dpm_force_performance_level
  '';
  setGPUPerfScriptWrap = pkgs.writeScript "set-gpu-performance.fish" ''
    #!${pkgs.fish}/bin/fish

    argparse "level=" -- $argv
    or begin
      echo "Usage: set-gpu-performance --level <auto|low|high>"
      exit 1
    end

    set level $_flag_level
    sudo ${setGPUPerfScript} --level={$level}
    if [ -n "$WAYLAND_DISPLAY" ]
      ${pkgs.libnotify}/bin/notify-send "Set GPU Performance Profile" "Level: $level"
    end
  '';
  setGPUPerfScriptPkg = pkgs.runCommand "cmd.set-gpu-performance.fish" {inherit setGPUPerfScript;} ''
    mkdir -p $out/bin
    ln -s ${setGPUPerfScriptWrap} $out/bin/set-gpu-performance
  '';
in {
  services.xserver.videoDrivers = ["amdgpu"];

  security.sudo = {
    extraRules = [
      {
        groups = ["wheel"];
        commands = [
          {
            command = "${setGPUPerfScript}";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };

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
    setGPUPerfScriptPkg
  ];

  systemd.packages = with pkgs; [lact];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  boot.kernelParams = ["amdgpu.ppfeaturemask=0xffffffff"];
}
