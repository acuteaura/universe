{pkgs, ...}: {
  home.packages = with pkgs;
    [
      (azure-cli.withExtensions [])
      act
      age
      age-plugin-yubikey
      android-tools
      atuin
      bandwhich
      bat
      binwalk
      bun
      chezmoi
      cilium-cli
      clang
      claude-code-acp
      claude-code-wrapped-claude
      claude-code-wrapped-claude-hardened
      claude-code-wrapped-zai
      clusterctl
      deno
      devbox
      direnv
      dust
      eza
      fastfetch
      fd
      ffmpeg
      fly
      fzf
      gh
      git-annex
      go
      gopls
      hcloud
      helm-docs
      hyfetch
      iperf
      jq
      just
      k9s
      kind
      kubectl
      kubectx
      kubelogin
      kubernetes-helm
      kustomize
      lima
      lzip
      macchina
      micro
      minikube
      minisign
      ncdu
      neovim
      nix-output-monitor
      nmap
      nodejs_22
      nushell
      opentofu
      p7zip
      pgo-client
      rclone
      restic
      ripgrep
      rustup
      sd
      semgrep
      socat
      sqlite
      starship
      syncthing
      talosctl
      tcpdump
      tmux
      tshark
      typst
      uutils-coreutils
      whois
      yq-go
      yt-dlp
      zellij
      zstd
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      bash
      qemu
      fish

      colima
      docker-client
      docker-buildx
      docker-credential-helpers
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [

      distrobox

      # hardware tools
      dmidecode
      pciutils
      powertop
      s-tui
      stress
      usbutils
      hdparm
    ];

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
}
