{pkgs, ...}: {
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    fuzzel
    waybar
    mako
    xwayland-satellite
  ];
}
