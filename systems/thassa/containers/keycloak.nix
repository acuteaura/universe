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
      image = "docker.io/library/postgres:16.3";
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
      image = "quay.io/aurelias/keycloak@sha256:f1abde2a114a253cbd907284e2126043b7cfb941ee6b6ff8cf6acc84f8ac82ca ";
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
