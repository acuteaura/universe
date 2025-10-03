{pkgs, ...}: {
  home.packages = with pkgs;
    [
      age
      age-plugin-yubikey
      attic-client
      atuin
      chezmoi
      devbox
      direnv
      fd
      git-annex
      gitversion
      hyfetch
      internetarchive
      iperf
      jq
      lzip
      micro
      ncdu
      neovim

      p7zip
      pgo-client
      pv
      rclone
      restic
      ripgrep
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

      # languages and compilers
      bun
      go
      nodejs_22
      nushell
      clang
      rustup

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
    ]
    ++ lib.optionals (pkgs.stdenv.isDarwin) [
      bash
      qemu

      colima
      docker-client
      docker-buildx
      docker-credential-helpers
    ]
    ++ lib.optionals (pkgs.stdenv.isLinux) [
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
