{
  options,
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  options.modules.develop.cc = {
    enable = mkEnableOption "C/C++ development environment";
  };

  config = mkIf config.modules.develop.cc.enable (mkMerge [
    {
      user.packages = with pkgs; [
        gcc
        ccls
        gdb
        gnumake
        xmake
        uncrustify
      ];
    }

    (mkIf config.modules.develop.xdg.enable {
      home.sessionVariables.UNCRUSTIFY_CONFIG = "${config.snowflake.configDir}/uncrustify/kNr.cfg";
    })
  ]);
}
