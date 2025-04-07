{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      age
      alejandra
      attic-client
      btop
      chezmoi
      curl
      dig
      direnv
      efm-langserver
      fd
      file
      fish
      git
      git-annex
      hyfetch
      iperf
      jq
      just
      micro
      neovim
      nil
      nixd
      rclone
      restic
      ripgrep
      socat
      starship
      syncthing
      tmux
      uutils-coreutils-noprefix
      whois
      yq-go
      zellij
      zstd
    ]
    ++ lib.optionals (pkgs.stdenv.isDarwin) [
      bash
      qemu
    ]
    ++ lib.optionals (pkgs.stdenv.isLinux) [
      # broken dependency on darwin: sleuthkit
      # ...because nixpkgs doesn't give a shit about darwin
      binwalk
    ];
}
