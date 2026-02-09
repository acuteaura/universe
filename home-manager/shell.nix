{pkgs, ...}: {
  home.packages = with pkgs;
    [
      (azure-cli.withExtensions [])
      act
      age-plugin-yubikey
      android-tools
      atuin
      bandwhich
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
      ffmpeg
      fly
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
      micro
      minikube
      mistral-vibe
      ncdu
      neovim
      nmap
      nodejs_22
      nushell
      opentofu
      p7zip
      pgo-client
      rclone
      restic
      rustup
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
