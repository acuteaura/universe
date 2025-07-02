{
  fetchurl,
  appimageTools,
}: let
  pname = "headlamp";
  version = "0.32.0";
  src = fetchurl {
    url = "https://github.com/kubernetes-sigs/headlamp/releases/download/v${version}/Headlamp-${version}-linux-x64.AppImage";
    hash = "sha256-mKDmrjieSJViDlyB1TPB70ta4vsCAq7PXEeV16m7Op4=";
  };
  appimageContents = appimageTools.extract {inherit pname version src;};
  headlamp = appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      mkdir -p $out/share/applications $out/share/icons/hicolor
      cp ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
      cp -r ${appimageContents}/usr/share/icons/hicolor $out/share/icons
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    '';

    extraPkgs = pkgs: [
      pkgs.kubelogin
      pkgs.azure-cli
    ];
  };
in
  headlamp
