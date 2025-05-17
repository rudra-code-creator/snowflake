{
  config,
  lib,
  pkgs,
  ...
}:
{

  imports = [ ./hardware.nix ];

  # ----------------------------------------------
  # GLOBAL NIXOS MODULES
  # ----------------------------------------------

  # KDE-Connect + Start-up indicator
  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent;
  };

  services = {
    upower.enable = true;
    libinput.touchpad = {
      accelSpeed = "0.5";
      accelProfile = "adaptive";
    };
  };

  # ----------------------------------------------
  #LOCAL RUCORP MODULES
  # ----------------------------------------------
  modules = {
    networking = {
      networkManager.enable = true;
    };

    base.enable = true;

    # Finally, our beloved hardware module(s):
    hardware = {
      # plymouth.enable = true;
      pipewire.enable = true;
      bluetooth.enable = true;
      pointer.enable = true;
      printer.enable = true;
    };

    develop = {
      cc.enable = true;
      go.enable = true;
      lisp.guile.enable = true;
      python.enable = true;
      rust.enable = true;
      markup = {
        language.enable = true;
        LaTeX.enable = true;
      };
    };

    themes.active = "catppuccin";
    # themes.active = "kanagawa";

    services = {
      flatpaks.enable = true;
      ssh.enable = true;
      rustdesk.enable = true;
      fail2ban.enable = true;
    };

    desktop = {

      session.gnome.enable = true;
      # session.hyprland.enable = true;
      # session.xmonad.enable = true;

      education = {
        memorization.enable = true;
        vidcom.enable = false;
      };

      distractions = {
        steam.enable = true;
        lutris.enable = true;
        lutris.league.enable = true;
      };

      terminal = {
        program = "ghostty";
        alacritty.enable = true;
        ghostty.enable = true;
        kitty.enable = true;
        wezterm.enable = true;
      };
      editors = {
        default = "nvim";
        emacs.enable = true;
        neovim.enable = true;
      };
      browsers = {
        default = "zen";
        zen.enable = true;
        # nyxt.enable = true;
      };
      
      toolset = {
        graphics = {
          raster.enable = true;
          vector.enable = true;
        };
        player = {
          music.enable = true;
          video.enable = true;
        };
        recorder = {
          enable = true;
          video.enable = true;
        };
        communication = {
          base.enable = true;
          # matrix.enable = true;
          mu4e.enable = true;
        };
        readers = {
          enable = true;
          program = "zathura";
        };
      };
    };

    shell = {
      default = "fish";
      toolset = {
        git.enable = true;
        android.enable = true;
      };
    };
  };
}
