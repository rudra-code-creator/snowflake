{
  config,
  lib,
  pkgs,
  ...
}:
{

  imports = [ ./hardware.nix ];

  modules = {
    networking = {
      networkManager.enable = true;
    };

    themes.active = "catppuccin";

    services = {
      flatpaks.enable = true;
    };

    desktop = {

      session.gnome.enable = true;
      # session.hyprland.enable = true;

      terminal = {
        program = "ghostty";
        alacritty.enable = true;
        ghostty.enable = true;
        kitty.enable = true;
        wezterm.enable = true;
      };
      editors = {
        default = "nvim";
        neovim.enable = true;
      };
      browsers = {
        default = "zen";
        zen.enable = true;
      };
      toolset = {
        player.video.enable = true;
        readers = {
          enable = true;
          program = "zathura";
        };
      };
    };

    shell = {
      default = "fish";
      toolset.git.enable = true;
    };
  };
}
