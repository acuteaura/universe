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
      image = "quay.io/aurelias/keycloak@sha256:84abf536ce5769563a2d86ea68f7787db4842f077605abf7cb8ace37a2749c62";
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
