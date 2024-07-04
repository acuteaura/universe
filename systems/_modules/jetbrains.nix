{ config, pkgs, ... }:
{
  /*  nixpkgs.overlays = [
    (final: prev:
    let
      toolNames = ["goland"];
      makeToolOverlay = toolName: {
        ${toolName} = prev.jetbrains.${toolName}.overrideAttrs (old: {
          patches = (old.patches or []) ++ [ ./JetbrainsRemoteDev.patch ];
          installPhase = (old.installPhase or "") + ''
            makeWrapper "$out/$pname/bin/remote-dev-server.sh" "$out/bin/$pname-remote-dev-server" \
              --prefix PATH : "$out/libexec/$pname:${final.lib.makeBinPath [ final.jdk final.coreutils final.gnugrep final.which final.git ]}" \
              --prefix LD_LIBRARY_PATH : "${final.lib.makeLibraryPath ([ final.stdenv.cc.cc.lib final.libsecret final.e2fsprogs final.libnotify ])}" \
              --set-default JDK_HOME "${final.jetbrains.jdk}" \
              --set-default JAVA_HOME "${final.jetbrains.jdk}"
          '';
        });
      };
    in { jetbrains = prev.jetbrains // builtins.foldl' (acc: toolName: acc // makeToolOverlay toolName) {} toolNames; })
  ];*/

  environment.systemPackages = with pkgs; [
    jetbrains.goland
    jetbrains.jdk
  ];
}
