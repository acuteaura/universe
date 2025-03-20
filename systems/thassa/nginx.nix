{
  pkgs,
  lib,
  ...
}: {
  services.nginx = let
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
    defaultListenIPv4 = [
      {
        addr = "0.0.0.0";
        port = 80;
        ssl = false;
      }
      {
        addr = "0.0.0.0";
        port = 443;
        ssl = true;
      }
    ];
    cloudflareListenIPv4 = [
      {
        addr = "0.0.0.0";
        port = 49152;
        ssl = true;
      }
    ];
    defaultListenIPv6 = [
      {
        addr = "[::]";
        port = 80;
        ssl = false;
      }
      {
        addr = "[::]";
        port = 443;
        ssl = true;
      }
    ];
    cloudflareListenIPv6 = [
      {
        addr = "[::]";
        port = 49152;
        ssl = true;
      }
    ];
  in {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."78.47.161.199" = {
      listen = defaultListenIPv4 ++ defaultListenIPv6 ++ cloudflareListenIPv4 ++ cloudflareListenIPv6;
      rejectSSL = true;
      default = true;
      locations."/" = {
        return = "404";
      };
    };

    virtualHosts."id.nullvoid.space" = {
      listen = cloudflareListenIPv4 ++ cloudflareListenIPv6;
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/certificates/nullvoid.space-cf.crt";
      sslCertificateKey = "/etc/certificates/nullvoid.space-cf.key";
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 256M;
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
      locations."/resources" = {
        proxyPass = "http://127.0.0.1:8080";
        proxyWebsockets = true;
      };
      locations."/realms/nvs/metrics" = {
        extraConfig = ''
          deny all;
        '';
      };
      extraConfig = ''
        ssl_client_certificate /etc/certificates/authenticated_origin_pull_ca.pem;
        ssl_verify_client on;
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

  networking.firewall.allowedTCPPorts = [80 443 49152];
}
