{
  options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.virtualisation.containers.transmission;
in
with lib;
{
  options.modules.virtualisation.containers.transmission = with types; {
    enable = mkEnableOption "BitTorrent client";
    username = mkOption {
      type = str;
      default = "alonzo";
      example = "username";
      description = "Transmission RPC User-Name";
    };
    password = mkOption {
      type = str;
      example = "password";
      description = "Transmission RPC User-Password";
    };
    download-dir = mkOption {
      type = path;
      default = "${config.user.home}/Downloads/Torrents";
      example = "xyz";
      description = "The directory where torrents ought to be saved";
    };
  };

  config = mkIf cfg.enable {
    user = {
      packages = [ pkgs.transmission-remote-gtk ];
      extraGroups = [ "transmission" ];
    };

    containers.transmission = {
      autoStart = false;
      ephemeral = true;
      enableTun = true;

      privateNetwork = true;
      hostAddress = "192.168.102.10";
      localAddress = "192.168.102.11";

      bindMounts = {
        "/var/lib/transmission" = {
          hostPath = "/var/lib/transmission";
          isReadOnly = false;
        };

        "/home/torrents" = {
          hostPath = cfg.download-dir;
          isReadOnly = false;
        };
      };
    };

    containers.transmission.config = {
      # TODO: config file /= existant
      # + wg-quick-VPN /= exist + no pinging.
      # + nixos-container root-login transmission => only way to access (currently).
      # (?) web-app status unknown due to failed login attempt.

      systemd.services.transmission = {
        bindsTo = [ "" ];
        after = [ "" ];
      };

      networking.firewall = {
        allowedTCPPorts = [
          9091
          51413
        ];
        allowedUDPPorts = [ 51413 ];
      };

      services.transmission = {
        enable = true;
        settings = {
          # Manage transmisson file locations:
          download-dir = "/home/torrents/completed";
          incomplete-dir = "/home/torrents/.incomplete";
          incomplete-dir-enabled = true;
          watch-dir-enabled = false;
          rename-partial-files = true;

          # Control transmisson ports:
          rpc-port = 9091;
          rpc-whitelist-enabled = true;
          rpc-whitelist = "127.0.0.1,192.168.*.*";
          rpc-bind-address = "0.0.0.0";

          rpc-username = cfg.username;
          rpc-password = cfg.password;
          rpc-authentication-required = true;

          peer-port = 51413;
          peer-socket-tos = "lowcost";

          # Extras settings:
          umask = 2;
          encryption = 2;
          message-level = 1;
          utp-enabled = true;

          ratio-limit = 0;
          ratio-limit-enabled = true;

          speed-limit-up-enabled = true;
          speed-limit-up = 1;
          idle-seeding-limit-enabled = true;
          idle-seeding-limit = 0;
        };
      };
    };
  };
}
