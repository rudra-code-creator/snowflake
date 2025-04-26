{
  options,
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  options.modules.shell.toolset.skim = {
    enable = mkEnableOption "TUI Fuzzy Finder.";
  };

  config = mkIf config.modules.shell.toolset.skim.enable {
    hm.programs.skim = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = config.modules.shell.default == "zsh";
      enableFishIntegration = config.modules.shell.default == "fish";

      defaultCommand = "fd --type f";
      defaultOptions = [
        "--height 40%"
        "--prompt ⟫"
      ];
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = [ "--preview 'head {}'" ];
      historyWidgetOptions = [
        "--tac"
        "--exact"
      ];
    };
  };
}
