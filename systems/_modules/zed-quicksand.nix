{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.universe.zed-quicksand;

  zed-quicksand = pkgs.writeShellScriptBin "zed-quicksand" ''
    # Get the original zed binary
    ZED_BIN="${pkgs.zed-editor}/bin/zeditor"

    # Get the user's home directory
    REAL_HOME="''${HOME:-/home/$USER}"

    # Sandbox home directory - isolated from real home (XDG compliant)
    XDG_STATE_HOME="''${XDG_STATE_HOME:-''${REAL_HOME}/.local/state}"
    SANDBOX_HOME="''${XDG_STATE_HOME}/zed-quicksand/home"
    mkdir -p "''${SANDBOX_HOME}"

    # Projects directory that will be accessible (same path inside and outside)
    SANDBOXED_PROJECTS="''${REAL_HOME}/Projects/sandboxed"
    mkdir -p "''${SANDBOXED_PROJECTS}"

    # Create a temporary directory for the sandbox
    TMPDIR="''${TMPDIR:-/tmp}"

    # Fixed home directory path inside the sandbox
    SANDBOXED_HOME="/home/aurelia"

    # Zed needs more access than just claude (GPU, X11/Wayland, etc.)
    exec ${pkgs.bubblewrap}/bin/bwrap \
      --ro-bind /nix /nix \
      --ro-bind /etc /etc \
      --ro-bind /run /run \
      --ro-bind /sys /sys \
      --symlink /run/current-system/sw/bin /bin \
      --symlink /run/current-system/sw/bin /usr/bin \
      --proc /proc \
      --dev-bind /dev /dev \
      --tmpfs /tmp \
      --bind "''${TMPDIR}" /tmp \
      --bind "''${SANDBOX_HOME}" "''${SANDBOXED_HOME}" \
      --bind "''${SANDBOXED_PROJECTS}" "''${SANDBOXED_PROJECTS}" \
      --ro-bind "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}" "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}" \
      --setenv HOME "''${SANDBOXED_HOME}" \
      --setenv USER "''${USER}" \
      --setenv DISPLAY "''${DISPLAY}" \
      --setenv WAYLAND_DISPLAY "''${WAYLAND_DISPLAY}" \
      --setenv XDG_RUNTIME_DIR "''${XDG_RUNTIME_DIR}" \
      --setenv PATH "/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin" \
      --unshare-pid \
      --die-with-parent \
      --new-session \
      "''${ZED_BIN}" "''${@}"
  '';
in {
  options.universe.zed-quicksand = with lib; {
    enable = mkEnableOption "Enable sandboxed Zed wrapper";

    projectsDir = mkOption {
      type = types.str;
      default = "~/Projects";
      description = "Directory that claude should have write access to";
    };
  };

  config = lib.mkIf cfg.enable {
    # Ensure bubblewrap is available
    environment.systemPackages = [
      zed-quicksand
    ];

    # Create desktop entry for zed-quicksand
    environment.etc."xdg/applications/zed-quicksand.desktop".text = ''
      [Desktop Entry]
      Name=Zed (Sandboxed)
      Comment=High-performance, multiplayer code editor (Sandboxed with bubblewrap)
      Exec=${zed-quicksand}/bin/zed-quicksand %F
      Icon=zed
      Terminal=false
      Type=Application
      Categories=Development;TextEditor;
      MimeType=text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
      StartupNotify=true
      StartupWMClass=dev.zed.Zed
    '';
  };
}
