{ ... }:
{
  virtualisation.quadlet.networks.keycloak = {};
  
  fileSystems."/data/keycloak" = {
    device = "/dev/disk/by-id/scsi-0HC_Volume_101019958";
    type = "ext4";
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
}