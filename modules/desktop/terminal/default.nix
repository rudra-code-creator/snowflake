{
  options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.desktop.terminal;
in
with lib;
{
  options.modules.desktop.terminal = with types; {
    enable = mkEnableOption "A terminal emulator to live inside";
    program = mkOption {
      type = nullOr (enum [
        "alacritty"
        "kitty"
        "ghostty"
        "wezterm"
        "xterm"
      ]);
      default = "kitty";
      description = "the default terminal emulator to be installed/used.";
    };
  };

  config = mkMerge [
    {
      home.sessionVariables.TERMINAL = cfg.program;
      services.xserver.desktopManager.xterm.enable = mkDefault (cfg.program == "xterm");
    }

    (mkIf (cfg.program != "alacritty") {
      user.packages = [ pkgs.chafa ];
    })

    (mkIf (config.modules.desktop.session.type == "x11") {
      services.xserver.excludePackages = mkIf (cfg.program != "xterm") [ pkgs.xterm ];
    })
  ];
}
