{pkgs, ...}: let
  # claude-zen: Claude Code enhanced with Z.AI powers 🧘
  # Because regular Claude is cool, but Z.AI Claude achieves enlightenment
  claude-zen = pkgs.writeShellApplication {
    name = "claude-zen";
    runtimeInputs = [pkgs.claude-code];
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
  claude-claude = pkgs.writeShellApplication {
    name = "claude";
    runtimeInputs = [pkgs._1password-cli pkgs.claude-code];
    text = ''
      # Set up Claude environment variables
      export ANTHROPIC_AUTH_TOKEN="$CLAUDE_API_KEY"
      export CLAUDE_CONFIG_DIR="$HOME/.config/claude-code"

      # Launch claude-code with the retrieved API key
      exec claude "$@"
    '';
  };
in {
  home.packages = with pkgs;
    [
      age-plugin-yubikey
      atuin
      chezmoi
      devbox
      direnv
      git-annex
      ffmpeg
      hyfetch
      iperf
      jq
      lzip
      micro
      ncdu
      neovim
      p7zip
      pgo-client
      rclone
      restic
      socat
      sqlite
      starship
      syncthing
      tmux
      uutils-coreutils
      yq-go
      yt-dlp
      zellij
      zstd
      whois
      zellij

      # devops shit
      act
      (azure-cli.withExtensions [])
      fly
      gh
      opentofu
      just
      hcloud

      # sec
      nmap
      semgrep
      tcpdump
      tshark
      bandwhich

      # languages and compilers
      bun
      go
      nodejs_22
      nushell
      clang
      rustup
      gopls

      # k8s stuff
      cilium-cli
      clusterctl
      helm-docs
      k9s
      kind
      kubectl
      kubectx
      kubelogin
      kubernetes-helm
      kustomize
      minikube
      talosctl

      lima

      claude-claude
      claude-zen
      mistral-vibe-wrapped
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      bash
      qemu

      colima
      docker-client
      docker-buildx
      docker-credential-helpers
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      binwalk

      distrobox
      docker-machine-kvm2

      # hardware tools
      dmidecode
      pciutils
      powertop
      s-tui
      stress
      usbutils
      hdparm
    ];
}
