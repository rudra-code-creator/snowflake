{
  options,
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  options.modules.hardware.pointer = {
    enable = mkEnableOption "pointer control";
  };

  config = mkIf config.modules.hardware.pointer.enable (mkMerge [
    {
      services.libinput = {
        enable = true;
        mouse = {
          middleEmulation = false;
          disableWhileTyping = true;
        };
        touchpad = {
          scrollMethod = "twofinger";
          naturalScrolling = true;
          tapping = true;
          tappingDragLock = false;
          disableWhileTyping = true;
        };
      };
    }

    (mkIf (config.modules.desktop.session.type == "x11") {
      services.unclutter-xfixes = {
        enable = true;
        extraOptions = [
          "exclude-root"
          "ignore-scrolling"
        ];
        threshold = 1;
        timeout = 1;
      };
    })
  ]);
}
