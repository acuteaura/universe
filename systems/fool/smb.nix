{...}: {
  services.samba = {
    enable = true;

    # no need to open legacy ports
    openFirewall = false;

    settings = {
      global = {
        "server string" = "fool";
        "workgroup" = "TRANSCOMMUNE";

        "server min protocol" = "SMB3";
        "client min protocol" = "SMB3";
        "disable netbios" = "yes";

        "guest account" = "nobody";
        "map to guest" = "bad user";
        "use sendfile" = "yes";
        "min receivefile size" = "16384";

        "aio read size" = "16384";
        "aio write size" = "16384";

        "vfs objects" = "catia fruit streams_xattr";

        "fruit:nfs_aces" = "no";
        "fruit:resource" = "xattr";
        "fruit:metadata" = "stream";
        "fruit:encoding" = "native";
      };

      aurelia = {
        path = "/home/aurelia";
        browseable = true;
        writable = true;
        "valid users" = "aurelia";
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [445];
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
