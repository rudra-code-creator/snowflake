{
  options,
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  options.modules.develop.nix = {
    enable = mkEnableOption "Nix development" // {
      default = true;
    };
  };

  config = mkIf config.modules.develop.nix.enable (mkMerge [
    {
      user.packages = with pkgs; [
        nixfmt-rfc-style
        nixd
        manix
        # nix-index # Provided in flake
        nix-init
        nix-output-monitor
        nix-tree
        nix-update
        nixpkgs-review
      ];
    }

    (mkIf config.modules.develop.xdg.enable {
      # TODO:
    })
  ]);
}
