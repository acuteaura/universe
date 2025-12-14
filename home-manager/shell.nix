{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      age-plugin-yubikey
      atuin
      chezmoi
      devbox
      direnv
      git-annex
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
      (azure-cli.withExtensions [ ])
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

      # the "thanks i hate it" tools
      claude-code
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
