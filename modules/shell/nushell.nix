{
  options,
  config,
  lib,
  pkgs,
  ...
}:

let
  activeTheme = config.modules.themes.active;
in
with lib;
{
  config = mkIf (config.modules.shell.default == "nushell") {
    modules.shell = {
      corePkgs.enable = true;
      toolset.starship.enable = true;
    };
    hm.programs.starship.enableNushellIntegration = true;

    hm.programs.nushell = {
      enable = true;
      plugins = with pkgs.nushellPlugins; [
        formats
        highlight
        net
        polars
        query
        units
      ];
      settings = {
        completions.external = {
          enable = true;
          max_results = 200;
        };
      };
      shellAliases =
        let
          abbrevs = import "${config.snowflake.configDir}/shell-abbr.nix";
        in
        concatStrings (
          mapAttrsToList (k: v: ''
            abbr ${k}=${strings.escapeNixString v}
          '') abbrevs
        );
    };
  };
}
