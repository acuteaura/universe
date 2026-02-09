final: prev: let
  # Generic wrapper for claude-code with different configurations
  mkClaudeWrapper = {
    name,
    configDir,
    env ? {},
    preScript ? "",
    runtimeInputs ? [],
    hardened ? false,
  }:
    final.writeShellApplication {
      inherit name;
      runtimeInputs =
        [final.claude-code]
        ++ runtimeInputs
        ++ final.lib.optionals hardened [final.bubblewrap final.coreutils];
      text = ''
        ${preScript}
        ${builtins.concatStringsSep "\n" (
          builtins.attrValues (builtins.mapAttrs (k: v: ''export ${k}="${v}"'') env)
        )}
        export CLAUDE_CONFIG_DIR="${configDir}"

        ${
          if hardened
          then ''
            # Ensure config dir exists
            mkdir -p "$CLAUDE_CONFIG_DIR"

            exec bwrap \
              --ro-bind /nix /nix \
              --ro-bind /etc /etc \
              --ro-bind /run /run \
              --ro-bind "$HOME/.config/fish" "$HOME/.config/fish" \
              --proc /proc \
              --dev /dev \
              --bind "$(pwd)" "$(pwd)" \
              --bind "$CLAUDE_CONFIG_DIR" "$CLAUDE_CONFIG_DIR" \
              --bind "$HOME/.npm" "$HOME/.npm" \
              --chdir "$(pwd)" \
              --setenv HOME "$HOME" \
              --setenv CLAUDE_CODE_SHELL "$SHELL" \
              --unshare-pid \
              --unshare-uts \
              --unshare-cgroup \
              --share-net \
              --new-session \
              --die-with-parent \
              claude "$@"
          ''
          else ''
            exec claude "$@"
          ''
        }
      '';
    };
in {
  inherit mkClaudeWrapper;

  claude-code-wrapped-claude = mkClaudeWrapper {
    name = "ccode-claude";
    configDir = "$HOME/.config/claude-code";
  };

  claude-code-wrapped-claude-hardened = mkClaudeWrapper {
    name = "ccode-claude-hardened";
    configDir = "$HOME/.config/claude-code";
  };

  claude-code-wrapped-zai = mkClaudeWrapper {
    name = "ccode-zai";
    configDir = "$HOME/.config/claude-zai";
    preScript = ''
      # Check if op (1Password CLI) is available in PATH
      if ! command -v op &> /dev/null; then
          echo "Error: 'op' (1Password CLI) not found in PATH" >&2
          echo "Please install 1Password CLI and ensure it's available in your PATH" >&2
          exit 1
      fi

      # Retrieve API key from 1Password
      ANTHROPIC_AUTH_TOKEN=$(op read "op://agoz6xpan4yq6zkpzmfipbvab4/mpfrptyjsujjfw7gxd7z3geehi/password") || {
          echo "Error: Failed to retrieve API key from 1Password" >&2
          echo "Make sure you're signed in with 'op signin' or 'eval \$(op signin)'" >&2
          exit 1
      }
      export ANTHROPIC_AUTH_TOKEN
    '';
    env = {
      ANTHROPIC_BASE_URL = "https://api.z.ai/api/anthropic";
      API_TIMEOUT_MS = "3000000";
    };
  };
}
