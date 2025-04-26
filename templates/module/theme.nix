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
          package = pkgs.tokyonight-gtk.override { themeVariants = [ "Dark-BL" ]; };
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
              black = "";
              red = "";
              green = "";
              yellow = "";
              blue = "";
              magenta = "";
              cyan = "";
              white = "";
            };
            bright = {
              black = "";
              red = "";
              green = "";
              yellow = "";
              blue = "";
              magenta = "";
              cyan = "";
              white = "";
            };
            types = {
              fg = "";
              bg = "";
              panelbg = "";
              border = "";
              highlight = "";
            };
          };

          rofi = with cfg.colors.main; {
            bg = {
              main = "";
              alt = "";
              bar = "";
            };
            fg = "";
            ribbon = {
              outer = "";
              inner = "";
            };
            selected = "";
            urgent = "";
          };
        };

        editor = {
          helix = {
            dark = "";
            light = "";
          };
          neovim = {
            dark = "";
            light = "";
          };
        };
      };
    }
  ]);
}
