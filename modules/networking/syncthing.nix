{
  options,
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  options.modules.networking.syncthing = {
    enable = mkEnableOption "enable continuous file-synchronization between multiple devices";
  };

  config = mkIf config.modules.networking.syncthing.enable {
    networking.firewall = {
      allowedTCPPorts = [
        8384
        22000
      ];
      allowedUDPPorts = [
        22000
        21027
      ];
    };

    services.syncthing =
      let
        syncDir = (builtins.getEnv "HOME") + "/Documents/Syncthing";
      in
      {
        enable = true;
        extraOptions.gui = {
          user = "${config.user.name}";
          password = "password"; # :TODO| replace with agenix alternative
        };
        dataDir = syncDir + "/data";
        configDir = syncDir + "/config";

        overrideDevices = true;
        overrideFolders = true;
        devices = {
          "device1" = {
            id = "DEVICE-ID-GOES-HERE";
          };
          "device2" = {
            id = "DEVICE-ID-GOES-HERE";
          };
        };

        folders = {
          "Documents" = {
            # Name of folder in Syncthing, also the folder ID
            path = syncDir + "/data";
            devices = [
              "device1"
              "device2"
            ];
          };
        };
      };
  };
}
