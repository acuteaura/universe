{...}: {
  virtualisation.quadlet.autoEscape = true;

  virtualisation.quadlet.networks.keycloak = {};

  virtualisation.quadlet.containers.keycloak-postgres = {
    containerConfig = {
      name = "keycloak-postgres";
      hostname = "keycloak-postgres";
      image = "docker.io/library/postgres:16.10";
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
        "/data"
      ];
      ConditionPathExists = ["/etc/keycloak.env"];
    };
  };

  virtualisation.quadlet.containers.keycloak = {
    containerConfig = {
      name = "keycloak";
      hostname = "keycloak";
      image = "quay.io/aurelias/keycloak:a07006f8ab74ded5204931e207b5fe81927fe40f";
      environments = {
        "KC_DB" = "postgres";
        "KC_DB_URL_HOST" = "keycloak-postgres";
        "KC_DB_URL_DATABASE" = "postgres";
        "KC_DB_USERNAME" = "postgres";
        "KC_HOSTNAME" = "https://id.nullvoid.space";
        "JAVA_OPTS_APPEND" = "-Djava.net.preferIPv4Stack=false -Djava.net.preferIPv6Addresses=true";
      };
      environmentFiles = [
        "/etc/keycloak.env"
      ];
      networks = ["keycloak.network"];
      publishPorts = [
        "127.0.0.1:8080:8080"
      ];
    };
    unitConfig = {
      After = ["network.target" "keycloak-postgres.service"];
      Wants = ["network.target" "keycloak-postgres.service"];
      ConditionPathExists = ["/etc/keycloak.env"];
    };
  };
}
