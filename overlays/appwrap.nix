final: prev: {
  claude-code-wrapped-claude = final.writeShellApplication {
    name = "ccode-claude";
    runtimeInputs = [final.claude-code];
    text = ''
      # Set up Claude environment variables
      export CLAUDE_CONFIG_DIR="$HOME/.config/claude-code"

      # Launch claude-code with the retrieved API key
      exec claude "$@"
    '';
  };

  claude-code-wrapped-zai = final.writeShellApplication {
    name = "ccode-zai";
    runtimeInputs = [final.claude-code];
    text = ''
      # Check if op (1Password CLI) is available in PATH
      if ! command -v op &> /dev/null; then
          echo "Error: 'op' (1Password CLI) not found in PATH" >&2
          echo "Please install 1Password CLI and ensure it's available in your PATH" >&2
          exit 1
      fi

      # Source the Z.AI API key from 1Password
      ZAI_API_KEY=$(op read "op://agoz6xpan4yq6zkpzmfipbvab4/mpfrptyjsujjfw7gxd7z3geehi/password" || {
          echo "Error: Failed to retrieve Z.AI API key from 1Password" >&2
          echo "Make sure you're signed in with 'op signin' or 'eval \$(op signin)'" >&2
          exit 1
      })

      # Set up Z.AI environment variables
      export ANTHROPIC_AUTH_TOKEN="$ZAI_API_KEY"
      export ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic"
      export API_TIMEOUT_MS="3000000"
      export CLAUDE_CONFIG_DIR="$HOME/.config/claude-zen"

      # Launch claude-code with Z.AI configuration
      exec claude "$@"
    '';
  };
}
