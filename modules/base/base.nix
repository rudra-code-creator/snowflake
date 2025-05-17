{
  options,
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  options.modules.base = {
    enable = mkEnableOption "circuit design";
  };

  config = mkIf config.modules.base.enable {
    # TODO: OSS packages + configuration.
    user.packages = [ pkgs.kicad ];
  };
}