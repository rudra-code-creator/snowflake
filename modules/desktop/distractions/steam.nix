{
  options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.desktop.distractions.steam;
in
with lib;
{
  options.modules.desktop.distractions.steam = {
    enable = mkEnableOption "Enable steam, the game/software store";
    hardware.enable = mkEnableOption "Support for steam hardware";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.steam = {
        enable = true;
        package = pkgs.steam-small.override {
          extraEnv = {
            DXVK_HUD = "compiler";
            MANGOHUD = true;
            # RADV_TEX_ANISO = 16;
          };
        };
      };
      hardware.steam-hardware.enable = mkForce cfg.hardware.enable;

      # https://github.com/FeralInteractive/gamemode
      programs.gamemode = {
        enable = true;
        enableRenice = true;
        settings = { };
      };
    }

    (mkIf (config.modules.desktop.session.type == "wayland") {
      # https://github.com/ValveSoftware/gamescope
      programs.gamescope = {
        enable = true;
        capSysNice = true;
        env = {
          DXVK_HDR = "1";
          ENABLE_GAMESCOPE_WSI = "1";
          WINE_FULLSCREEN_FSR = "1";
          WLR_RENDERER = "vulkan";
        };
        args = [ "--hdr-enabled" ];
      };

      programs.steam.gamescopeSession = {
        enable = true;
        args = [ "--immediate-flips" ];
      };
    })
  ]);
}
