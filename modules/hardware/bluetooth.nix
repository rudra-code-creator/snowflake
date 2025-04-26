{
  options,
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  options.modules.hardware.bluetooth = {
    enable = mkEnableOption "bluetooth support";
  };

  config = mkIf config.modules.hardware.bluetooth.enable {
    user.packages = with pkgs; [
      overskride
      galaxy-buds-client
    ];

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
        ControllerMode = "dual";
        FastConnectable = true;
        Experimental = true;
        KernelExperimental = true;
      };
    };

    systemd.user.services.mpris-proxy = {
      description = "mpris-proxy -> bluetooth (media) ctrl";
      after = [
        "network.target"
        "sound.target"
      ];
      wantedBy = [ "default.target" ];
      serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    };
  };
}
