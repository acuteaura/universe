{
  lib,
  writeShellScriptBin,
  bubblewrap,
  zellij,
  coreutils,
  gnugrep,
  nix,
  bash,
  strace,
}:
writeShellScriptBin "claude-sandboxed" ''
    set -euo pipefail

    # Parse arguments
    USE_STRACE=0
    PORT=8080

    while [[ $# -gt 0 ]]; do
      case $1 in
        --strace)
          USE_STRACE=1
          shift
          ;;
        *)
          PORT="$1"
          shift
          ;;
      esac
    done

    # Get current working directory
    PROJECT_DIR="$(pwd)"

    # Create a hash of the project directory for unique home
    PROJECT_HASH=$(echo -n "$PROJECT_DIR" | ${coreutils}/bin/sha256sum | ${coreutils}/bin/cut -d' ' -f1 | ${coreutils}/bin/cut -c1-16)

    XDG_STATE_HOME="''${XDG_STATE_HOME:-''$HOME/.local/state}"

    # Create per-project home directory
    SANDBOX_HOME="$XDG_STATE_HOME/claude-sandboxed/homes/$PROJECT_HASH"
    mkdir -p "$SANDBOX_HOME"

    # Create runtime directory for zellij sockets
    SANDBOX_RUNTIME="$XDG_STATE_HOME/claude-sandboxed/runtime/$PROJECT_HASH"
    mkdir -p "$SANDBOX_RUNTIME"
    chmod 0700 "$SANDBOX_RUNTIME"

    # Create zellij config and layouts directory
    ZELLIJ_CONFIG_DIR="$SANDBOX_HOME/.config/zellij"
    ZELLIJ_LAYOUTS_DIR="$ZELLIJ_CONFIG_DIR/layouts"
    mkdir -p "$ZELLIJ_LAYOUTS_DIR"

    # Create default layout file for claude + shell tabs
    cat > "$ZELLIJ_LAYOUTS_DIR/default.kdl" <<'EOF'
  layout {
      tab name="Claude" {
          pane command="claude"
      }
      tab name="Shell" {
          pane command="bash"
      }
  }
  EOF

    # Common bubblewrap flags
    BWRAP_FLAGS=(
      --ro-bind /nix /nix
      --ro-bind /etc /etc
      --ro-bind /sys /sys
      --symlink /run/current-system/sw/bin /bin
      --symlink /run/current-system/sw/bin /usr/bin
      --proc /proc
      --dev-bind /dev /dev
      --tmpfs /tmp
      --tmpfs /run
      --bind "$SANDBOX_HOME" "$HOME"
      --bind "$PROJECT_DIR" "$PROJECT_DIR"
      --chdir "$PROJECT_DIR"
      --setenv HOME "$HOME"
      --setenv ZELLIJ_CONFIG_DIR "$HOME/.config/zellij"
      --unshare-all
      --share-net
      --die-with-parent
    )

    # Create a web token if it doesn't exist
    TOKEN_FILE="$SANDBOX_HOME/.zellij-token.txt"
    if [ ! -f "$TOKEN_FILE" ]; then
      echo "Creating web authentication token..."
      mkdir -p "$SANDBOX_HOME/.local/share/zellij"
      # Run zellij web --create-token in the sandbox to create a token
      TOKEN_OUTPUT=$(${bubblewrap}/bin/bwrap "''${BWRAP_FLAGS[@]}" ${zellij}/bin/zellij web --create-token 2>&1)

      # Extract just the token line (format: "token_X: uuid")
      TOKEN_LINE=$(echo "$TOKEN_OUTPUT" | ${gnugrep}/bin/grep -E '^token_[0-9]+:')
      echo "$TOKEN_LINE" > "$TOKEN_FILE"
      echo ""
      echo "Token created and saved to: $TOKEN_FILE"
      echo "$TOKEN_LINE"
      echo ""
      echo "You will need this token to log in to the web interface."
      echo ""
    fi

    echo "Starting zellij web server on port $PORT..."
    echo "Access at: http://127.0.0.1:$PORT/"
    if [ -f "$TOKEN_FILE" ]; then
      echo "Authentication token:"
      ${coreutils}/bin/cat "$TOKEN_FILE"
      echo ""
    fi

    # Build the command to run
    if [ "$USE_STRACE" -eq 1 ]; then
      echo "strace enabled, output to stderr"
      echo ""
      ZELLIJ_CMD="${strace}/bin/strace -f -e trace=openat,open,write,read,mkdir,access,stat,lstat ${zellij}/bin/zellij"
    else
      ZELLIJ_CMD="${zellij}/bin/zellij"
    fi

    # Build bubblewrap command
    exec ${bubblewrap}/bin/bwrap "''${BWRAP_FLAGS[@]}" $ZELLIJ_CMD
''
