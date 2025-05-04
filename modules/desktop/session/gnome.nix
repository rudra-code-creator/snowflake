{
  options,
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  options.modules.desktop.session.gnome = {
    enable = mkEnableOption "modern desktop environment";
  };

  config = mkIf config.modules.desktop.session.gnome.enable {
    modules.desktop = {
      session.type = "wayland";
      terminal.program = "ghostty";
      extensions.input-method = {
        enable = true;
        framework = "fcitx";
      };
    };

    services.xserver.desktopManager.gnome.enable = true;

    services.gnome = {
      gnome-keyring.enable = true;
      gnome-browser-connector.enable = true;
      sushi.enable = true;
    };

    programs.dconf.enable = true;
    services.udev.packages = [ pkgs.gnome-settings-daemon ];

    user.packages =
      with pkgs;
      [
        dconf2nix
        polari
        gnome-disk-utility
        gnome-tweaks
      ]
      ++ (with gnomeExtensions; [
        appindicator
        # aylurs-widgets
        blur-my-shell
        dash-to-dock
        gsconnect
        just-perfection
        openweather-refined # pop-shell
        removable-drive-menu
        rounded-window-corners-reborn
        space-bar
        user-themes
      ]);

    environment.sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };
}
