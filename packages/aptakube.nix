{
  fetchurl,
  appimageTools,
}: let
  pname = "aptakube";
  version = "1.11.10";
  src = fetchurl {
    url = "https://releases.aptakube.com/aptakube_${version}_amd64.AppImage";
    hash = "sha256-7IzTxuZ/KtXUyvOqzCKpAlgXDu3ZzZeye/j5W1hI9K8=";
  };
  appimageContents = appimageTools.extract {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      mkdir -p $out/share/applications $out/share/icons/hicolor
      cp ${appimageContents}/usr/share/applications/${pname}.desktop $out/share/applications/${pname}.desktop
      cp -r ${appimageContents}/usr/share/icons/hicolor $out/share/icons
    '';

    extraPkgs = pkgs: [
      pkgs.kubelogin
      pkgs.azure-cli
    ];
  }
