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
    HOME_DIR="''${HOME:-/home/$USER}"
    PROJECTS_DIR="''${HOME_DIR}/Projects"

    # Create a temporary directory for the sandbox
    TMPDIR="''${TMPDIR:-/tmp}"

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
      --bind "''${HOME_DIR}/.config" "''${HOME_DIR}/.config" \
      --bind "''${HOME_DIR}/.local" "''${HOME_DIR}/.local" \
      --bind "''${HOME_DIR}/.cache" "''${HOME_DIR}/.cache" \
      --bind "''${PROJECTS_DIR}" "''${PROJECTS_DIR}" \
      --ro-bind "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}" "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}" \
      --setenv HOME "''${HOME_DIR}" \
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
  };
}
