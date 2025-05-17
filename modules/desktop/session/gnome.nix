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

    services.udev.packages = [ pkgs.gnome-settings-daemon ];
    services.sysprof.enable = true;

    user.packages =
      with pkgs;
      [
        dconf2nix
        polari
        gnome-disk-utility
        gnome-tweaks
        warp-terminal
        warp
        warpinator
        cloudflare-warp

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

    environment.gnome.excludePackages = with pkgs; [
      # orca
      evince
      # file-roller
      geary
      gnome-disk-utility
      # seahorse
      # sushi
      # sysprof
      #
      # gnome-shell-extensions
      #
      # adwaita-icon-theme
      # nixos-background-info
      # gnome-backgrounds
      # gnome-bluetooth
      # gnome-color-manager
      # gnome-control-center
      # gnome-shell-extensions
      # gnome-tour # GNOME Shell detects the .desktop file on first log-in.
      # gnome-user-docs
      # glib # for gsettings program
      # gnome-menus
      # gtk3.out # for gtk-launch program
      # xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
      # xdg-user-dirs-gtk # Used to create the default bookmarks
      #
      baobab
      epiphany
      gnome-text-editor
      gnome-calculator
      gnome-calendar
      gnome-characters
      # gnome-clocks
      gnome-console
      gnome-contacts
      # gnome-font-viewer
      gnome-logs
      gnome-maps
      gnome-music
      # gnome-system-monitor
      gnome-weather
      # loupe
      # nautilus
      # gnome-connections
      # simple-scan
      # snapshot
      # totem
      # yelp
      # gnome-software
    ];

    programs.dconf.enable = true;

    programs.dconf.profiles.user.databases = [{
      lockAll = false; # prevents overriding
      settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = with pkgs; [
            gnomeExtensions.gsconnect.extensionUuid
            gnomeExtensions.dash-to-dock.extensionUuid
          ];
        };
        "org/gnome/desktop/interface" = {
          clock-show-weekday = true;
          color-scheme = "prefer-dark";
        };
        # Configure individual extensions
        # "org/gnome/shell/extensions/blur-my-shell" = {
        #   brightness = 0.75;
        #   noise-amount = 0;
        # };
      };
    }];
  };
}
