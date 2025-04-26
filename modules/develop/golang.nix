{
  options,
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  options.modules.develop.go = {
    enable = mkEnableOption "Go development" // {
      default = true;
    };
  };

  config = mkIf config.modules.develop.go.enable (mkMerge [
    {
      user.packages = with pkgs; [
        go
        gopls
      ];
    }

    (mkIf config.modules.develop.xdg.enable {
      # TODO:
    })
  ]);
}
