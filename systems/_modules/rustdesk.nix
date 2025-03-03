{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    rustdesk-flutter
  ];
}
