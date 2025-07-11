{
  options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.networking;
in
with lib;
{
  options.modules.networking = {
    iwd.enable = mkEnableOption "wpa_supplicant alt.";
    networkd.enable = mkEnableOption "systemd network manager";
    networkManager.enable = mkEnableOption "powerful network manager";
  };

  config = mkMerge [
    {
      # General networking settings we want available
      networking.firewall.enable = true;
    }

    (mkIf cfg.iwd.enable {
      networking.wireless.iwd = {
        enable = true;
        settings = {
          General = {
            AddressRandomization = "network";
            AddressRandomizationRange = "full";
            EnableNetworkConfiguration = true;
            RoamRetryInterval = 15;
          };
          Network = {
            EnableIPv6 = true;
            RoutePriorityOffset = 300;
            # NameResolvingService = "resolvconf";
          };
          Settings = {
            AutoConnect = true;
            # AlwaysRandomizeAddress = false;
          };
          Rank.BandModifier5Ghz = 2.0;
          Scan.DisablePeriodicScan = true;
        };
      };

      # A GUI for easier network management:
      user.packages = [ pkgs.iwgtk ];

      # Launch indicator as a daemon on login:
      systemd.user.services.iwgtk = {
        serviceConfig.ExecStart = "${getExe pkgs.iwgtk} -i";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
      };
    })

    (mkIf cfg.networkManager.enable {
      systemd.services.NetworkManager-wait-online.enable = false;

      networking.networkmanager = {
        enable = mkDefault true;
        wifi.backend = "wpa_supplicant";
      };

      # Display a network-manager applet:
      hm.services.network-manager-applet.enable = true;
    })

    # TODO: add network connections + ragenix.
    (mkIf cfg.networkd.enable {
      systemd.network.enable = true;

      systemd.services = {
        systemd-networkd-wait-online.enable = false;
        systemd-networkd.restartIfChanged = false;
        firewall.restartIfChanged = false;
      };

      networking.interfaces = {
        enp1s0.useDHCP = true;
        wlan0.useDHCP = true;
      };
    })
  ];
}
