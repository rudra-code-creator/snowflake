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
  config = mkIf (cfg.active == "catppuccin") (mkMerge [
    {
      modules.themes = {
        wallpaper = mkDefault ./assets/alena-aenami-new-year.jpg;

        gtk = {
          name = "Catppuccin-Dark";
          package = pkgs.my.catppuccin-gtk;
        };
        iconTheme = {
          name = "WhiteSur-dark";
          package = pkgs.whitesur-icon-theme;
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
              black = "#6e6c7e";
              red = "#f28fad";
              green = "#abe9b3";
              yellow = "#fae3b0";
              blue = "#96cdfb";
              magenta = "#f5c2e7";
              cyan = "#89dceb";
              white = "#d9e0ee";
            };
            bright = {
              black = "#988ba2";
              red = "#f28fad";
              green = "#abe9b3";
              yellow = "#fae3b0";
              blue = "#96cdfb";
              magenta = "#f5c2e7";
              cyan = "#89dceb";
              white = "#d9e0ee";
            };
            types = {
              fg = "#d9e0ee";
              bg = "#1e1d2f";
              panelbg = "#b5e8e0";
              border = "#c9cbff";
              highlight = "#f2cdcd";
            };
          };

          rofi = with cfg.colors.main; {
            bg = {
              main = types.bg;
              alt = "#171320";
              bar = "#1F1D26";
            };
            fg = types.fg;
            ribbon = {
              outer = "#F5D5D5";
              inner = "#6BA8F7";
            };
            selected = "#D6D0FF";
            urgent = "#E87A9D";
          };

        };

        editor = {
          helix = {
            dark = "catppuccin_mocha";
            light = "catppuccin_latte";
          };
          neovim = {
            dark = "catppuccin";
            light = "catppuccin"; # TODO apply frappe flavour
          };
        };
      };
    }

    (mkIf config.services.xserver.enable {

      hm.programs.sioyek.config = with cfg.font; {
        "custom_background_color " = "0.12 0.11 0.18";
        "custom_text_color " = "0.85 0.88 0.93";

        "text_highlight_color" = "0.85 0.88 0.93";
        "visual_mark_color" = "0.27 0.28 0.35 1.0";
        "search_highlight_color" = "0.95 0.55 0.66";
        "link_highlight_color" = "0.59 0.80 0.98";
        "synctex_highlight_color" = "0.96 0.88 0.86";

        "page_separator_width" = "2";
        "page_separator_color" = "0.95 0.80 0.80";
        "status_bar_color" = "0.19 0.20 0.27";

        "font_size" = "${builtins.toString default.size}";
        "ui_font" = "${monospace.family} ${monospace.weight}";
      };
    })
  ]);
}
