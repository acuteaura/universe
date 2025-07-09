{pkgs, ...}: {
  home.packages = with pkgs;
    [
      age
      age-plugin-yubikey
      archivebox
      attic-client
      atuin
      btop
      chezmoi
      cryptsetup
      curl
      devbox
      dig
      direnv
      fd
      ffmpeg
      file
      fish
      git
      git-annex
      gitversion
      gnugrep
      gnumake
      gnupg
      gnused
      htop
      hyfetch
      internetarchive
      iperf
      jq
      llvm
      lzip
      micro
      ncdu
      neovim
      openssl
      p7zip
      pgo-client
      pv
      rclone
      restic
      ripgrep
      socat
      sqlite
      sshfs
      starship
      syncthing
      tmux
      unrar-free
      uutils-coreutils
      wget
      whois
      yq-go
      yt-dlp
      zellij
      zstd

      # devops shit
      act
      azure-cli
      fly
      gh
      opentofu
      just

      # sec
      nmap
      semgrep
      tcpdump
      tshark
      hcloud

      # languages
      bun
      go
      nodejs_22
      nushell

      # language servers and tools
      alejandra
      clang
      efm-langserver
      eslint
      nil
      nixd
      nixpkgs-fmt
      nufmt
      rustup
      tailwindcss-language-server
      typescript-language-server
      vue-language-server
      yaml-language-server

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
    ]
    ++ lib.optionals (pkgs.stdenv.isDarwin) [
      bash
      qemu

      colima
      lima
      docker-client
      docker-buildx
      docker-credential-helpers
    ]
    ++ lib.optionals (pkgs.stdenv.isLinux) [
      # broken dependency on darwin: sleuthkit
      # ...because nixpkgs doesn't give a shit about darwin
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
