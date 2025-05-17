{
  options,
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  options.modules.develop.jetbrains = {
    enable = mkEnableOption "Jetbrains development";
  };

  config = mkIf config.modules.develop.nix.enable (mkMerge [
    {
      user.packages = with pkgs.jetbrains; [
        rust-rover
      ];
    }

    (mkIf config.modules.develop.xdg.enable {
      # TODO:
    })
  ]);
}
