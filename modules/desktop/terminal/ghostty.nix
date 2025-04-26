{
  options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.desktop.terminal;
  activeTheme = config.modules.themes.active;
in
with lib;
{
  options.modules.desktop.terminal.ghostty = {
    enable = mkEnableOption "GPU-accelerated terminal emulator";
  };

  config = mkIf (cfg.enable && (cfg.program == "ghostty")) {
    hm.programs.ghostty = {
      enable = true;
      clearDefaultKeybinds = true;
      settings =
        {
          confirm-close-surface = false;
          copy-on-select = "clipboard";
          app-notifications = "no-clipboard-copy";

          keybind =
            (mapAttrsToList (name: value: "alt+${name}=${value}") {
              h = "goto_split:left";
              j = "goto_split:bottom";
              k = "goto_split:top";
              l = "goto_split:right";
            })
            ++ (mapAttrsToList (name: value: "ctrl+alt+${name}=${value}") {
              n = "next_tab";
              p = "previous_tab";

              a = "new_split:left";
              j = "new_split:down";
              k = "new_split:up";
              l = "new_split:right";
              f = "toggle_split_zoom";
            })
            ++ (mapAttrsToList (name: value: "ctrl+shift+${name}=${value}") {
              c = "copy_to_clipboard";
              v = "paste_from_clipboard";

              z = "jump_to_prompt:-2";
              x = "jump_to_prompt:2";

              h = "write_scrollback_file:paste";
              i = "inspector:toggle";

              page_down = "scroll_page_fractional:0.33";
              down = "scroll_page_lines:1";
              j = "scroll_page_lines:1";

              page_up = "scroll_page_fractional:-0.33";
              up = "scroll_page_lines:-1";
              k = "scroll_page_lines:-1";

              home = "scroll_to_top";
              end = "scroll_to_bottom";

              enter = "reset_font_size";
              plus = "increase_font_size:1";
              minus = "decrease_font_size:1";
            });

          theme = "custom";
          background-opacity = 0.8;
          gtk-titlebar = false;
          cursor-style-blink = false;
          mouse-hide-while-typing = true;
          window-decoration = false;
          window-padding-x = 10;
          window-padding-y = 10;
        }
        // optionalAttrs (activeTheme != null) (
          with config.modules.themes.font;
          {
            font-family = monospace.family;
            font-size = monospace.size;
            font-style = monospace.weight;
          }
        );

      themes = mkIf (activeTheme != null) {
        custom =
          with config.modules.themes.colors.main;
          let
            colors = {
              "0" = normal.black;
              "1" = normal.red;
              "2" = normal.green;
              "3" = normal.yellow;
              "4" = normal.blue;
              "5" = normal.magenta;
              "6" = normal.cyan;
              "7" = normal.white;
              "8" = bright.black;
              "9" = bright.red;
              "10" = bright.green;
              "11" = bright.yellow;
              "12" = bright.blue;
              "13" = bright.magenta;
              "14" = bright.cyan;
              "15" = bright.white;
            };
          in
          {
            background = types.bg;
            foreground = types.fg;
            cursor-color = normal.yellow;
            cursor-text = types.bg;
            selection-background = types.highlight;
            selection-foreground = types.bg;
            palette = mapAttrsToList (name: value: name + "=" + value) colors;
          };
      };
    };
  };
}
