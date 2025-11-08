{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.claude-sandbox;

  # Create the wrapped claude binary with configurable paths
  claude-sandboxed = pkgs.writeShellScriptBin "claude" ''
    # Get the original claude binary
    CLAUDE_BIN="${pkgs.claude-code}/bin/claude"

    # Get the user's home directory
    HOME_DIR="''${HOME}"

    # Projects directory - use configured value or default
    PROJECTS_DIR="${cfg.projectsDir}"

    # Expand tilde in PROJECTS_DIR if present
    if [[ "''${PROJECTS_DIR}" == "~/"* ]]; then
      PROJECTS_DIR="''${HOME_DIR}/''${PROJECTS_DIR#~/}"
    fi

    # Ensure projects directory exists
    mkdir -p "''${PROJECTS_DIR}"

    # Build additional read-only bind arguments
    EXTRA_RO_BINDS=()
    ${lib.concatMapStringsSep "\n" (path: ''
      EXTRA_RO_BINDS+=(--ro-bind "${path}" "${path}")
    '') cfg.extraReadOnlyPaths}

    # Build additional writable bind arguments
    EXTRA_RW_BINDS=()
    ${lib.concatMapStringsSep "\n" (path: ''
      EXTRA_RW_BINDS+=(--bind "${path}" "${path}")
    '') cfg.extraWritablePaths}

    exec ${pkgs.bubblewrap}/bin/bwrap \
      --ro-bind /nix /nix \
      --ro-bind /etc/resolv.conf /etc/resolv.conf \
      --ro-bind /etc/hosts /etc/hosts \
      --ro-bind /etc/ssl /etc/ssl \
      --ro-bind /etc/static/ssl /etc/static/ssl 2>/dev/null \
      --ro-bind /etc/ca-certificates /etc/ca-certificates 2>/dev/null \
      --ro-bind /run/current-system/sw /run/current-system/sw \
      --symlink /run/current-system/sw/bin /bin \
      --symlink /run/current-system/sw/bin /usr/bin \
      --proc /proc \
      --dev /dev \
      --tmpfs /tmp \
      --ro-bind "''${HOME_DIR}/.config" "''${HOME_DIR}/.config" \
      --bind "''${HOME_DIR}/.local/share/claude" "''${HOME_DIR}/.local/share/claude" \
      --bind "''${HOME_DIR}/.cache/claude" "''${HOME_DIR}/.cache/claude" \
      --bind "''${PROJECTS_DIR}" "''${PROJECTS_DIR}" \
      "''${EXTRA_RO_BINDS[@]}" \
      "''${EXTRA_RW_BINDS[@]}" \
      --setenv HOME "''${HOME_DIR}" \
      --setenv USER "''${USER}" \
      --setenv PATH "/run/current-system/sw/bin:''${HOME_DIR}/.nix-profile/bin:/nix/var/nix/profiles/default/bin" \
      ${lib.optionalString cfg.unshareNetwork "--unshare-net"} \
      --unshare-pid \
      --die-with-parent \
      --new-session \
      "''${CLAUDE_BIN}" "''${@}"
  '';
in {
  options.programs.claude-sandbox = with lib; {
    enable = mkEnableOption "Enable sandboxed claude wrapper with bubblewrap";

    projectsDir = mkOption {
      type = types.str;
      default = "~/Projects";
      description = "Directory that claude should have write access to (supports ~ expansion)";
    };

    extraReadOnlyPaths = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "/path/to/readonly" ];
      description = "Additional paths to mount as read-only in the sandbox";
    };

    extraWritablePaths = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "/path/to/writable" ];
      description = "Additional paths to mount as writable in the sandbox";
    };

    unshareNetwork = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to disable network access in the sandbox (not recommended for claude)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      claude-sandboxed
      pkgs.bubblewrap
    ];
  };
}
