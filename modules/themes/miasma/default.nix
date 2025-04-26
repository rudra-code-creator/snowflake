{
  options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.themes;
in
with lib;
{
  config = mkIf (cfg.active == "miasma") (mkMerge [
    {
      modules.themes = {
        wallpaper = mkDefault ./assets/girl-reading-book.png;
        gtk = {
          name = "Orchis-Green-Dark";
          package = pkgs.orchis-theme;
        };
        iconTheme = {
          name = "WhiteSur-green-dark";
          package = pkgs.whitesur-icon-theme.override { themeVariants = [ "green" ]; };
        };
        pointer = {
          name = "Bibata-Modern-Classic";
          package = pkgs.bibata-cursors;
        };

        font = {
          packages = with pkgs; [
            libre-baskerville
            maple-mono.NF-CN
            noto-fonts-emoji
          ];
          default.family = "Maple Mono NF CN";
          monospace.family = "Maple Mono NF CN";
          emoji.family = "Noto Color Emoji";
        };

        colors = {
          main = {
            normal = {
              black = "#000000";
              red = "#685742";
              green = "#5F875F";
              yellow = "#B36D43";
              blue = "#78824B";
              magenta = "#BB7744";
              cyan = "#C9A554";
              white = "#D7C483";
            };
            bright = {
              black = "#666666";
              red = "#685742";
              green = "#5F875F";
              yellow = "#B36D43";
              blue = "#78824B";
              magenta = "#BB7744";
              cyan = "#C9A554";
              white = "#D7C483";
            };
            types = {
              fg = "#C2C2B0";
              bg = "#222222";
              panelbg = "#D87A42";
              border = "#788C4B";
              highlight = "#E4C47A";
            };
          };

          rofi = with cfg.colors.main; {
            bg = {
              main = types.bg;
              alt = "#2A2A37";
              bar = "#353545";
            };
            fg = types.fg;
            ribbon = {
              outer = types.panelbg;
              inner = types.border;
            };
            selected = types.highlight;
            urgent = normal.magenta;
          };
        };

        editor = {
          helix = {
            dark = "miasma";
            light = "miasma";
          };
          neovim = {
            dark = "miasma";
            light = "miasma"; # :TODO| Integrate with Neovim
          };
        };
      };
    }

    (mkIf config.services.xserver.enable {
      hm.programs.sioyek.config = with cfg.font; {
        "custom_background_color " = "0.13 0.13 0.13";
        "custom_text_color " = "0.76 0.76 0.69";

        "text_highlight_color" = "0.69 0.43 0.26";
        "visual_mark_color" = "0.56 0.52 0.43 1.0";
        "search_highlight_color" = "0.73 0.42 0.34";
        "link_highlight_color" = "0.52 0.77 0.60";
        "synctex_highlight_color" = "0.79 0.65 0.33";

        "page_separator_width" = "2";
        "page_separator_color" = "0.50 0.48 0.46";
        "status_bar_color" = "0.20 0.22 0.33";

        "font_size" = "${builtins.toString default.size}";
        "ui_font" = "${monospace.family} ${monospace.weight}";
      };
    })
  ]);
}
