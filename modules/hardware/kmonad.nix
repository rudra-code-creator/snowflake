{
  inputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.hardware.kmonad;
in
with lib;
{
  options.modules.hardware.kmonad = with types; {
    enable = mkEnableOption "advanced kbd management";
    deviceID = mkOption {
      type = nullOr path;
      default = null;
      example = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
      description = "path to device.kbd file";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.kmonad.overlays.default ];

    # Allow our user to benefit from KMonad:
    user.extraGroups = [ "uinput" ];

    services.kmonad =
      let
        layoutFile = "${config.snowflake.hostDir}/kmonad/layout.kbd";
      in
      {
        enable = true;
        keyboards.options = {
          device = /dev/input/by-path/platform-i8042-serio-0-event-kbd;
          defcfg = {
            enable = true;
            fallthrough = true; # when keys /= assigned -> defsrc value
            allowCommands = false;
            compose.key = null;
          };
          config = if builtins.pathExists layoutFile then builtins.readFile layoutFile else "";
        };
      };
  };
}
