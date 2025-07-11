{
  options,
  config,
  lib,
  pkgs,
  ...
}:

let
  nodePkg = pkgs.nodejs_latest;
in
with lib;
{
  options.modules.develop.web = {
    enable = mkEnableOption "Web development";
  };

  config = mkIf config.modules.develop.web.enable (mkMerge [
    {
      user.packages =
        with pkgs;
        [
          nodePkg
          biome
        ]
        ++ (with nodePackages; [
          yarn
          typescript
          typescript-language-server
        ]);

      environment.shellAliases = {
        n = ''PATH="$(${nodePkg}/bin/npm bin):$PATH"'';
        ya = "yarn";
      };
      environment.variables.PATH = [ "$(${pkgs.yarn}/bin/yarn global bin)" ];
    }

    (mkIf config.modules.develop.xdg.enable {
      environment.variables = {
        NODE_REPL_HISTORY = "$XDG_CACHE_HOME/node/repl_history";
        NPM_CONFIG_CACHE = "$XDG_CACHE_HOME/npm";
        NPM_CONFIG_PREFIX = "$XDG_CACHE_HOME/npm";
        NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
        NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/config";
      };

      create.configFile."npm/config".text = ''
        cache=''${XDG_CACHE_HOME}/npm
        prefix=''${XDG_DATA_HOME}/npm
        tmp=''${XDG_RUNTIME_DIR}/npm
      '';
    })
  ]);
}
