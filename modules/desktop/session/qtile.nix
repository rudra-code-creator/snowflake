{
  inputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.desktop.session.qtile;
in
with lib;
{
  options.modules.desktop.session.qtile = with types; {
    enable = mkEnableOption "python x11/wayland WM";
    backend = mkOption {
      type = enum [
        "x11"
        "wayland"
      ];
      default = "x11";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      modules = {
        desktop = {
          session.type = cfg.backend;
          terminal.program = "alacritty";
          toolset.fileManager = {
            enable = true;
            program = "nautilus";
          };
          extensions = {
            input-method = {
              enable = true;
              framework = "fcitx";
            };
            mimeApps.enable = true; # mimeApps -> default launch application
            picom.enable = mkIf (cfg.backend == "x11");
            dunst.enable = true;
            rofi.enable = true;
          };
        };
        shell.scripts = {
          brightness.enable = true;
          screenshot.enable = true;
        };
        hardware.kmonad.enable = true;
      };

      environment.systemPackages =
        with pkgs;
        [
          libnotify
          playerctl
          gxmessage
        ]
        ++ optionals (cfg.backend == "x11") [
          xdotool
          feh
        ]
        ++ optional (cfg.backend == "wayland") [
          imv
          wf-recorder
        ];

      services.xserver.windowManager.qtile = {
        enable = true;
        configFile = "${config.snowflake.configDir}/qtile/config.py";
        backend = cfg.backend;
        # extraPackages = with pkgs.python3Packages; [ qtile-extras ];
      };
    }

    (mkIf (cfg.backend == "wayland") {
      environment.sessionVariables = {
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = "1";
      };
    })

    (mkIf (cfg.backend == "x11") {
      services.displayManager.defaultSession = "none+qtile";
    })
  ]);
}
