{
  options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.develop.markup;
  spellCheck = pkgs.aspellWithDicts (
    dicts: with dicts; [
      en
      en-computers
      en-science
      sv
    ]
  );

in
with lib;
{
  options.modules.develop.markup = {
    language.enable = mkEnableOption "verbal lang";
    LaTeX.enable = mkEnableOption "bloated markup+math lang";
    typst.enable = mkEnableOption "lightweight markup+math lang";
  };

  config = mkMerge [
    (mkIf cfg.LaTeX.enable {
      user.packages = with pkgs; [
        spellCheck
        harper
      ];
    })

    (mkIf cfg.LaTeX.enable {
      user.packages = with pkgs; [
        texlab
        texlive.combined.scheme-full
      ];
    })

    (mkIf cfg.typst.enable {
      user.packages = with pkgs; [
        typst
        tinymist
        typstyle
      ];
    })

    (mkIf config.modules.develop.xdg.enable {
      environment.sessionVariables.ASPELL_CONF = builtins.concatStringsSep ";" [
        "dict-dir ${getLib spellCheck}/lib/aspell"
        "per-conf $XDG_CONFIG_HOME/aspell/aspell.conf"
        "personal $XDG_CONFIG_HOME/aspell/en_US.pws"
        "repl $XDG_CONFIG_HOME/aspell/en.prepl"
      ];
    })
  ];
}
