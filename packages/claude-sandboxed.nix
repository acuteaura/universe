{
  lib,
  writeShellScriptBin,
  bubblewrap,
  zellij,
  coreutils,
  gnugrep,
  nix,
  bash,
}:
writeShellScriptBin "claude-sandboxed" ''
    set -euo pipefail

    # Parse arguments
    PORT=''${1:-8080}

    # Get current working directory
    PROJECT_DIR="$(pwd)"

    # Create a hash of the project directory for unique home
    PROJECT_HASH=$(echo -n "$PROJECT_DIR" | ${coreutils}/bin/sha256sum | ${coreutils}/bin/cut -d' ' -f1 | ${coreutils}/bin/cut -c1-16)

    XDG_STATE_HOME="''${XDG_STATE_HOME:-''$HOME/.local/state}"

    # Create per-project home directory
    SANDBOX_HOME="$XDG_STATE_HOME/claude-sandboxed/homes/$PROJECT_HASH"
    mkdir -p "$SANDBOX_HOME"

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

    # Create a web token if it doesn't exist
    TOKEN_FILE="$SANDBOX_HOME/.zellij-token.txt"
    if [ ! -f "$TOKEN_FILE" ]; then
      echo "Creating web authentication token..."
      mkdir -p "$SANDBOX_HOME/.local/share/zellij"
      # Run zellij web --create-token in the sandbox to create a token
      TOKEN_OUTPUT=$(${bubblewrap}/bin/bwrap \
        --ro-bind /nix /nix \
        --ro-bind /etc /etc \
        --ro-bind /run /run \
        --ro-bind /sys /sys \
        --symlink /run/current-system/sw/bin /bin \
        --symlink /run/current-system/sw/bin /usr/bin \
        --proc /proc \
        --dev-bind /dev /dev \
        --tmpfs /tmp \
        --tmpfs /run \
        --bind "$SANDBOX_HOME" "$HOME" \
        --bind "$PROJECT_DIR" "$PROJECT_DIR" \
        --chdir "$PROJECT_DIR" \
        --setenv HOME "$HOME" \
        --setenv ZELLIJ_CONFIG_DIR "$HOME/.config/zellij" \
        --unshare-all \
        --share-net \
        --die-with-parent \
        ${zellij}/bin/zellij web --create-token 2>&1)

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

    # Build bubblewrap command
    exec ${bubblewrap}/bin/bwrap \
      --ro-bind /nix /nix \
      --ro-bind /etc /etc \
      --ro-bind /run /run \
      --ro-bind /sys /sys \
      --symlink /run/current-system/sw/bin /bin \
      --symlink /run/current-system/sw/bin /usr/bin \
      --proc /proc \
      --dev-bind /dev /dev \
      --tmpfs /tmp \
      --bind "$SANDBOX_HOME" "$HOME" \
      --bind "$PROJECT_DIR" "$PROJECT_DIR" \
      --chdir "$PROJECT_DIR" \
      --setenv HOME "$HOME" \
      --setenv ZELLIJ_CONFIG_DIR "$HOME/.config/zellij" \
      --unshare-all \
      --share-net \
      --die-with-parent \
      ${zellij}/bin/zellij web --port "$PORT"
''
