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
  config = mkIf (cfg.active == "rose-pine") (mkMerge [
    {
      modules.themes = {
        wallpaper = mkDefault ./assets/oceanlife-turtle.jpg;
        gtk = {
          name = "rose-pine";
          package = pkgs.my.rose-pine-gtk;
        };
        iconTheme = {
          name = "rose-pine";
          package = pkgs.my.rose-pine-gtk;
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
              black = "#26233a";
              red = "#eb6f92";
              green = "#31748f";
              yellow = "#f6c177";
              blue = "#9ccfd8";
              magenta = "#c4a7e7";
              cyan = "#ebbcba";
              white = "#e0def4";
            };
            bright = {
              black = "#6e6a86";
              red = "#eb6f92";
              green = "#31748f";
              yellow = "#f6c177";
              blue = "#9ccfd8";
              magenta = "#c4a7e7";
              cyan = "#ebbcba";
              white = "#e0def4";
            };
            types = {
              fg = "#e0def4";
              bg = "#191724";
              panelbg = "#f9d6d2";
              border = "#bb7b79";
              highlight = "#c5b1e5";
            };
          };

          rofi = with cfg.colors.main; {
            bg = {
              main = types.bg;
              alt = "#181722";
              bar = "#1E1C2A";
            };
            fg = types.fg;
            ribbon = {
              outer = "#F5C9C2";
              inner = "#2F6A7A";
            };
            selected = "#3A3648";
            urgent = "#E06F8A";
          };
        };

        editor = {
          helix = {
            dark = "rose_pine";
            light = "rose_pine_dawn";
          };
          neovim = {
            dark = "rose-pine";
            light = "rose-pine-dawn"; # TODO: vim.g.tokyonight_style = "day"
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
