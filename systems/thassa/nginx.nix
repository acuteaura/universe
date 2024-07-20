{ pkgs, lib, ... }: {
  services.nginx =
    let
      realIpsFromList = lib.strings.concatMapStringsSep "\n" (x: "set_real_ip_from ${x};");
      allowFromList = lib.strings.concatMapStringsSep "\n" (x: "allow ${x};");
      fileToList = x: lib.strings.splitString "\n" (builtins.readFile x);
      cfipv4 = fileToList (pkgs.fetchurl {
        url = "https://www.cloudflare.com/ips-v4";
        sha256 = "0ywy9sg7spafi3gm9q5wb59lbiq0swvf0q3iazl0maq1pj1nsb7h";
      });
      cfipv6 = fileToList (pkgs.fetchurl {
        url = "https://www.cloudflare.com/ips-v6";
        sha256 = "1ad09hijignj6zlqvdjxv7rjj8567z357zfavv201b9vx3ikk7cy";
      });
    in
    {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts."78.47.161.199" = {
        rejectSSL = true;
        default = true;
        locations."/" = {
          return = "404";
        };
      };

      virtualHosts."id.nullvoid.space" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 256M;
            allow 89.1.7.228;
            deny all;
          '';
        };
        locations."/realms/nvs" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 256M;
          '';
        };
        extraConfig = ''
          ${realIpsFromList cfipv4}
          ${realIpsFromList cfipv6}
          real_ip_header CF-Connecting-IP;
        '';
      };
    };

  security.acme = {
    acceptTerms = true;
    defaults.email = "past.tree1213@cognitive-antivirus.net";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
