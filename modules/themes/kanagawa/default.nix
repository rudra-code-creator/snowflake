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
  config = mkIf (cfg.active == "kanagawa") (mkMerge [
    {
      modules.themes = {
        wallpaper = mkDefault ./assets/ismail-inceoglu-chaos-invoked.jpg;
        gtk = {
          name = "Kanagawa-Dark";
          package = pkgs.my.kanagawa-gtk;
        };
        iconTheme = {
          name = "Kanagawa";
          package = pkgs.my.kanagawa-gtk;
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
              black = "#090618";
              red = "#C34043";
              green = "#76946A";
              yellow = "#C0A36E";
              blue = "#7E9CD8";
              magenta = "#957FB8";
              cyan = "#6A9589";
              white = "#C8C093";
            };
            bright = {
              black = "#727169";
              red = "#FF5D62";
              green = "#98BB6C";
              yellow = "#E6C384";
              blue = "#7FB4CA";
              magenta = "#938AA9";
              cyan = "#7AA89F";
              white = "#DCD7BA";
            };
            types = {
              fg = "#DCD7BA";
              bg = "#1F1F28";
              panelbg = "#72A7BC";
              border = "#76946A";
              highlight = "#957FB8";
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
              outer = "#DCA460";
              inner = "#76956A";
            };
            selected = "#658695";
            urgent = "#C34143";
          };
        };

        editor = {
          helix = {
            dark = "kanagawa";
            light = "kanagawa";
          };
          neovim = {
            dark = "kanagawa";
            light = "Kanagawa_Light"; # :TODO| Integrate with Neovim
          };
        };
      };
    }

    (mkIf config.services.xserver.enable {
      hm.programs.sioyek.config = with cfg.font; {
        "custom_background_color " = "0.10 0.11 0.15";
        "custom_text_color " = "0.75 0.79 0.96";

        "text_highlight_color" = "0.24 0.35 0.63";
        "visual_mark_color" = "1.00 0.62 0.39 1.0";
        "search_highlight_color" = "0.97 0.46 0.56";
        "link_highlight_color" = "0.48 0.64 0.97";
        "synctex_highlight_color" = "0.62 0.81 0.42";

        "page_separator_width" = "2";
        "page_separator_color" = "0.81 0.79 0.76";
        "status_bar_color" = "0.34 0.37 0.54";

        "font_size" = "${builtins.toString default.size}";
        "ui_font" = "${monospace.family} ${monospace.weight}";
      };
    })
  ]);
}
