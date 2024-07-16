{ ... }:
{
  virtualisation.quadlet.networks.keycloak = {};
  
  fileSystems."/data/keycloak" = {
    device = "/dev/disk/by-id/scsi-0HC_Volume_101019958";
    fsType = "ext4";
  };

  virtualisation.quadlet.containers.keycloak-postgres = {
    containerConfig = {
      name = "keycloak_postgres";
      hostname = "keycloak_postgres";
      image = "docker.io/library/postgres:16.3";
      volumes = [
        "/data/keycloak/postgres:/var/lib/postgresql/data:U"
      ];
      environmentFiles = [
        "/etc/keycloak.env"
      ];
      networks = ["keycloak.network"];
    };
    unitConfig = {
      After = ["network.target"];
      Wants = ["network.target"];
      RequiresMountsFor = [
        "/data/keycloak"
      ];
    };
  };

  virtualisation.quadlet.containers.keycloak = {
    containerConfig = {
      name = "keycloak";
      hostname = "keycloak";
      image = "quay.io/aurelias/keycloak:389dae0dcd72acdcc0b8534f7d7502b6a48e089f@sha256:16aaf95083a135598eae8dac5e8988c7df180902b01f4b6345ce785642b68998";
      environments = {
        "KC_DB" = "postgres";
        "KC_DB_URL_HOST" = "keycloak_postgres";
        "KC_DB_URL_DATABASE" = "postgres";
        "KC_DB_USERNAME" = "postgres";
        "KC_HOSTNAME" = "id.nullvoid.space";
        "KEYCLOAK_ADMIN" = "root";
        "JAVA_OPTS_APPEND" = "-Djava.net.preferIPv4Stack=false -Djava.net.preferIPv6Addresses=true";
      };
      environmentFiles = [
        "/etc/keycloak.env"
      ];
      networks = ["keycloak.network"];
    };
    unitConfig = {
      After = ["network.target"];
      Wants = ["network.target"];
    };
  };
}