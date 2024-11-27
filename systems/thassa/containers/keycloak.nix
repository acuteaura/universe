{ ... }:
{
  virtualisation.quadlet.networks.keycloak = { };

  fileSystems."/data/keycloak" = {
    device = "/dev/disk/by-id/scsi-0HC_Volume_101019958";
    fsType = "ext4";
  };

  virtualisation.quadlet.containers.keycloak-postgres = {
    containerConfig = {
      name = "keycloak-postgres";
      hostname = "keycloak-postgres";
      image = "docker.io/library/postgres:16.6";
      volumes = [
        "/data/keycloak/postgres:/var/lib/postgresql/data:U"
      ];
      environmentFiles = [
        "/etc/keycloak.env"
      ];
      networks = [ "keycloak.network" ];
    };
    unitConfig = {
      After = [ "network.target" ];
      Wants = [ "network.target" ];
      RequiresMountsFor = [
        "/data/keycloak"
      ];
    };
  };

  virtualisation.quadlet.containers.keycloak = {
    containerConfig = {
      name = "keycloak";
      hostname = "keycloak";
      image = "quay.io/aurelias/keycloak:ae6017f21e07ab615623dd12c974309897768644@sha256:2670368af5169deaf5f50cdb4c5c67d5108db87f0f174cd0105998d50141ce2e";
      environments = {
        "KC_DB" = "postgres";
        "KC_DB_URL_HOST" = "keycloak-postgres";
        "KC_DB_URL_DATABASE" = "postgres";
        "KC_DB_USERNAME" = "postgres";
        "KC_HOSTNAME" = "id.nullvoid.space";
        "KEYCLOAK_ADMIN" = "root";
        "JAVA_OPTS_APPEND" = "-Djava.net.preferIPv4Stack=false -Djava.net.preferIPv6Addresses=true";
      };
      environmentFiles = [
        "/etc/keycloak.env"
      ];
      networks = [ "keycloak.network" ];
      publishPorts = [
        "127.0.0.1:8080:8080"
      ];
    };
    unitConfig = {
      After = [ "network.target" ];
      Wants = [ "network.target" ];
    };
  };
}
