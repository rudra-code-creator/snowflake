{
  options,
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  options.modules.desktop.toolset.recorder = {
    enable = mkEnableOption false;
    audio.enable = mkEnableOption "audio manipulation";
    video.enable = mkEnableOption "video manipulation";
  };

  config =
    let
      cfg = config.modules.desktop.toolset.recorder;
    in
    mkIf cfg.enable {
      services.pipewire.jack.enable = true;

      user.packages =
        with pkgs;
        [ ffmpeg-full ]
        ++ optionals cfg.audio.enable [
          audacity
          helvum
        ]
        ++ optionals cfg.video.enable [ obs-studio ];
    };
}
