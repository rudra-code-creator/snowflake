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
  config = mkIf (cfg.active == "tokyonight") (mkMerge [
    {
      modules.themes = {
        wallpaper = mkDefault ./assets/zaynstewart-anime-girl-night-alone.png;

        gtk = {
          name = "Tokyonight-Dark-BL";
          package = pkgs.my.tokyonight-gtk;
        };

        iconTheme = {
          name = "Fluent-orange-dark";
          package = pkgs.fluent-icon-theme.override { colorVariants = [ "orange" ]; };
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
              black = "#15161e";
              red = "#f7768e";
              green = "#9ece6a";
              yellow = "#e0af68";
              blue = "#7aa2f7";
              magenta = "#bb9af7";
              cyan = "#7dcfff";
              white = "#a9b1d6";
            };
            bright = {
              black = "#414868";
              red = "#f7768e";
              green = "#9ece6a";
              yellow = "#e0af68";
              blue = "#7aa2f7";
              magenta = "#bb9af7";
              cyan = "#7dcfff";
              white = "#c0caf5";
            };
            types = {
              fg = "#c0caf5";
              bg = "#1a1b26";
              panelbg = "#ff9e64";
              border = "#1abc9c";
              highlight = "#3d59a1";
            };
          };

          rofi = with cfg.colors.main; {
            bg = {
              main = types.bg;
              alt = "#18171F";
              bar = "#1F1E2A";
            };
            fg = types.fg;
            ribbon = {
              outer = "#1F4A4F";
              inner = "#1A3A4A";
            };
            selected = "#8FAEF5";
            urgent = "#F07A8F";
          };
        };

        editor = {
          helix = {
            dark = "tokyonight";
            light = "tokyonight_storm"; # FIXME: no `tokyonight_day` as of 2022-09-01
          };
          neovim = {
            dark = "tokyonight";
            light = "tokyonight"; # TODO: vim.g.tokyonight_style = "day"
          };
        };
      };
    }

    (mkIf config.services.xserver.enable {
      hm.programs.sioyek.config = with cfg.font.monospace; {
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

        "font_size" = "${builtins.toString size}";
        "ui_font" = "${family} ${weight}";
      };
    })
  ]);
}
