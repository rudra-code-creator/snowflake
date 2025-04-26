{
  options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.desktop.extensions.rofi;
  ui = config.modules.themes;
in
with lib;
{
  options.modules.desktop.extensions.rofi = {
    enable = mkEnableOption "window switcher and app-launcher";
    package = mkPackageOption pkgs "rofi" {
      default = if (config.modules.desktop.session.type == "wayland") then "rofi-wayland" else "rofi";
    };
  };

  # :TODO| re-create theming -> general + changable banner (drun, run, systemd and power-menu)

  config = mkIf cfg.enable {
    user.packages = [ pkgs.rofi-systemd ];

    hm.programs.rofi = {
      enable = true;
      package = cfg.package;
      plugins = [ pkgs.rofi-power-menu ];

      extraConfig = {
        terminal = "${config.modules.desktop.terminal.program}";
        disable-history = false;
        show-icons = true;
        sidebar-mode = false;
        sort = true;

        drun-display-format = "{icon} {name}";
        display-drun = "   Run ";
        display-window = " 﩯 Window ";
        display-power-menu = "  Power Menu ";

        modi = concatStringsSep "," [
          "run"
          "drun"
          "filebrowser"
          "power-menu:${lib.getExe pkgs.rofi-power-menu}"
        ];

        xoffset = 0;
        yoffset = 0;

        icon-theme = "${ui.iconTheme.name}";
        font =
          with ui.font;
          "${monospace.family} Italic ${monospace.weight} ${builtins.toString default.size}";
      };

      theme =
        let
          inherit (config.hm.lib.formats.rasi) mkLiteral;
        in
        with ui.colors.rofi;
        {
          "*" = {
            fg = mkLiteral "${fg}";
            bg = mkLiteral "${bg.main}";
            bg-alt = mkLiteral "${bg.alt}";
            bg-bar = mkLiteral "${bg.bar}";

            outer-ribbon = mkLiteral "${ribbon.outer}";
            inner-ribbon = mkLiteral "${ribbon.inner}";
            selected = mkLiteral "${selected}";
            urgent = mkLiteral "${urgent}";
            transparent = mkLiteral "#00000000";
          };

          "window" = {
            transparency = "real";
            background-color = mkLiteral "@bg";
            text-color = mkLiteral "@fg";
            border = mkLiteral "0% 0% 0% 1.5%";
            border-color = mkLiteral "@outer-ribbon";
            border-radius = mkLiteral "0% 0% 0% 2.5%";
            height = mkLiteral "54.50%";
            width = mkLiteral "43%";
            location = mkLiteral "center";
            x-offset = 0;
            y-offset = 0;
          };

          "prompt" = {
            enabled = true;
            padding = mkLiteral "0% 1% 0% 0%";
            background-color = mkLiteral "@bg-bar";
            text-color = mkLiteral "@fg";
          };

          "entry" = {
            background-color = mkLiteral "@bg-bar";
            text-color = mkLiteral "@fg";
            placeholder-color = mkLiteral "@fg";
            expand = true;
            horizontal-align = 0;
            placeholder = "Search";
            padding = mkLiteral "0.15% 0% 0% 0%";
            blink = true;
          };

          "inputbar" = {
            children = mkLiteral "[ prompt, entry ]";
            background-color = mkLiteral "@bg-bar";
            text-color = mkLiteral "@fg";
            expand = false;
            border = mkLiteral "0% 0% 0.3% 0.2%";
            border-radius = mkLiteral "1.5% 1.0% 1.5% 1.5%";
            border-color = mkLiteral "@inner-ribbon";
            margin = mkLiteral "0% 17% 0% 0%";
            padding = mkLiteral "1%";
            position = mkLiteral "center";
          };

          "listview" = {
            background-color = mkLiteral "@bg";
            columns = 5;
            spacing = mkLiteral "1%";
            cycle = false;
            dynamic = true;
            layout = mkLiteral "vertical";
          };

          "mainbox" = {
            background-color = mkLiteral "@bg";
            border = mkLiteral "0% 0% 0% 1.5%";
            border-radius = mkLiteral "0% 0% 0% 2.5%";
            border-color = mkLiteral "@inner-ribbon";
            children = mkLiteral "[ inputbar, listview ]";
            spacing = mkLiteral "3%";
            padding = mkLiteral "2.5% 2% 2.5% 2%";
          };

          "element" = {
            background-color = mkLiteral "@bg-bar";
            text-color = mkLiteral "@fg";
            orientation = mkLiteral "vertical";
            border-radius = mkLiteral "1.5% 1.0% 1.5% 1.5%";
            padding = mkLiteral "2% 0% 2% 0%";
          };

          "element-icon" = {
            background-color = mkLiteral "@transparent";
            text-color = mkLiteral "inherit";
            horizontal-align = "0.5";
            vertical-align = "0.5";
            size = mkLiteral "64px";
            border = mkLiteral "0px";
          };

          "element-text" = {
            background-color = mkLiteral "@transparent";
            text-color = mkLiteral "inherit";
            expand = true;
            horizontal-align = mkLiteral "0.5";
            vertical-align = mkLiteral "0.5";
            margin = mkLiteral "0.5% 1% 0% 1%";
          };

          "element normal.urgent, element alternate.urgent" = {
            background-color = mkLiteral "@urgent";
            text-color = mkLiteral "@fg";
            border-radius = mkLiteral "1%";
          };

          "element normal.active, element alternate.active" = {
            background-color = mkLiteral "@bg-alt";
            text-color = mkLiteral "@fg";
          };

          "element selected" = {
            background-color = mkLiteral "@selected";
            text-color = mkLiteral "@bg";
            border = mkLiteral "0% 0% 0.3% 0.2%";
            border-radius = mkLiteral "1.5% 1.0% 1.5% 1.5%";
            border-color = mkLiteral "@inner-ribbon";
          };

          "element selected.urgent" = {
            background-color = mkLiteral "@urgent";
            text-color = mkLiteral "@fg";
          };

          "element selected.active" = {
            background-color = mkLiteral "@bg-alt";
            color = mkLiteral "@fg";
          };
        };
    };
  };
}
