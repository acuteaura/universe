{ lib, config, pkgs, ... }:
{
  imports = [
    ../_modules/base.nix
    ../_modules/desktop-base.nix
    #../_modules/desktop-gnome.nix
    ../_modules/desktop-plasma.nix
    ../_modules/games.nix
    ../_modules/libvirt.nix
    ../_modules/containers.nix
    ../_modules/smb-nas.nix
    ../_modules/work.nix
    ./amdgpu.nix
    ./hardware.nix
  ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  time.timeZone = "Europe/Berlin";

  users.groups.aurelia = {
    name = "aurelia";
    gid = 1000;
  };

  users.users.aurelia = {
    isNormalUser = true;
    group = "aurelia";
    extraGroups = [ "wheel" "libvirtd" "docker" ];
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmjGIsSO9jE85xNPzzp0AWfOSXVL4qQ3cuXeKCvxe+q" ];
    shell = pkgs.fish;
  };

  programs._1password-gui.polkitPolicyOwners = [ "aurelia" ];
  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      librewolf
    '';
    mode = "644";
  };

  services.xserver.displayManager.gdm.enable = true;
  services.displayManager = {
    defaultSession = "plasma";
    sddm = {
      # broken with fish
      # https://github.com/NixOS/nixpkgs/issues/287646
      enable = false;
      wayland.enable = true;
    };
  };

  # tiebreaking required if you have gnome+kde
  #programs.ssh.askPassword = lib.mkForce "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";

  # locally installed packages
  environment.systemPackages = with pkgs; [
    qt6.qtimageformats
  ];

  # broken until everything upgrades electron
  #environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    SDL
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    SDL_image
    SDL_mixer
    SDL_ttf
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    bzip2
    cairo
    cups
    curlWithGnuTls
    dbus
    dbus-glib
    desktop-file-utils
    e2fsprogs
    expat
    flac
    fontconfig
    freeglut
    freetype
    fribidi
    fuse
    fuse3
    gdk-pixbuf
    glew110
    glib
    gmp
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    gtk2
    harfbuzz
    icu
    keyutils.lib
    libGL
    libGLU
    libappindicator-gtk2
    libcaca
    libcanberra
    libcap
    libclang.lib
    libdbusmenu
    libdrm
    libgcrypt
    libgpg-error
    libidn
    libjack2
    libjpeg
    libmikmod
    libogg
    libpng12
    libpulseaudio
    librsvg
    libsamplerate
    libthai
    libtheora
    libtiff
    libudev0-shim
    libusb1
    libuuid
    libvdpau
    libvorbis
    libvpx
    libxcrypt-legacy
    libxkbcommon
    libxml2
    mesa
    nspr
    nss
    openssl
    p11-kit
    pango
    pixman
    python3
    speex
    stdenv.cc.cc
    tbb
    udev
    vulkan-loader
    wayland
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXft
    xorg.libXi
    xorg.libXinerama
    xorg.libXmu
    xorg.libXrandr
    xorg.libXrender
    xorg.libXt
    xorg.libXtst
    xorg.libXxf86vm
    xorg.libpciaccess
    xorg.libxcb
    xorg.xcbutil
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    xorg.xkeyboardconfig
    xz
    zlib
  ];

  # random tools
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  
  services.xrdp.defaultWindowManager = "plasma";
  services.xrdp.enable = true;
  services.xrdp.openFirewall = true;

  services.printing.enable = true;
  services.tailscale.enable = true;
  #virtualisation.vmware.host.enable = true;
}
