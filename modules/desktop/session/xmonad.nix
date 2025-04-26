{
  inputs,
  options,
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  options.modules.desktop.session.xmonad = {
    enable = mkEnableOption "Haskell-based (functional) window manager";
  };

  config = mkIf config.modules.desktop.session.xmonad.enable {
    modules = {
      desktop = {
        session.type = "x11";
        terminal.program = "ghostty";
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
          picom = {
            enable = true;
            animation.enable = true;
          };
          dunst.enable = true;
          rofi.enable = true;
          taffybar.enable = true;
          # elkowar.enable = true;
        };
      };
      shell.scripts = {
        brightness.enable = true;
        screenshot.enable = true;
      };
      hardware.kmonad.enable = true;
    };

    nixpkgs.overlays = [
      inputs.xmonad.overlay
      inputs.xmonad-contrib.overlay
    ];

    environment.systemPackages = with pkgs; [
      libnotify
      playerctl
      gxmessage
      xdotool
      feh
      xorg.xwininfo
    ];

    services.xserver.displayManager.session = [
      {
        manage = "window";
        name = "none+xmonad";
        bgsupport = true;
        start = ''
          systemd-cat -t xmonad -- ${pkgs.runtimeShell} $HOME/.xsession ${getExe pkgs.haskellPackages.birostrisWM} > /dev/null 2>&1 &
          waitPID=$!
        '';
      }
    ];
  };
}
