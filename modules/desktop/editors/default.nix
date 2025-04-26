{
  options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.desktop.editors;
in
with lib;
{
  options.modules.desktop.editors = with types; {
    default = mkOption {
      type = nullOr (enum [
        "emacs"
        "helix"
        "nvim"
      ]);
      default = "emacs";
      description = "Default editor for text manipulation";
      example = "emacs";
    };
  };

  config = mkMerge [
    (mkIf (cfg.default != null) {
      home.sessionVariables = {
        EDITOR = cfg.default;
        OPENAI_API_KEY = "$(cat /run/agenix/ClosedAI)";
        OPENWEATHERMAP_KEY = "$(cat /run/agenix/OpenWeatherMap)";
      };
    })

    (mkIf (cfg.default == "nvim" || cfg.default == "emacs") {
      user.packages = with pkgs; [
        imagemagick
        editorconfig-core-c
        sqlite
        deno
        pandoc
      ];
    })
  ];
}
