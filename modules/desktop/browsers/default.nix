{
  options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.desktop.browsers;
in
with lib;
{
  options.modules.desktop.browsers = with types; {
    default = mkOption {
      type = nullOr str;
      default = null;
      description = "Default system browser";
      example = "zen";
    };
  };

  config = mkIf (cfg.default != null) { home.sessionVariables.BROWSER = cfg.default; };
}
