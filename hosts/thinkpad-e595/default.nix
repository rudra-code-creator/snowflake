{
  config,
  lib,
  pkgs,
  ...
}:
{

  imports = [ ./hardware.nix ];

  modules = {
    shell = {
      default = "fish";
      toolset = {
        git.enable = true;
        android.enable = true;
      };
    };
    networking.networkManager.enable = true;
    services.ssh.enable = true;

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

    themes.active = "kanagawa";
    desktop = {
      session.xmonad.enable = true;
      terminal.enable = true;
      editors = {
        default = "emacs";
        emacs.enable = true;
        neovim.enable = true;
      };
      browsers = {
        default = "zen";
        zen.enable = true;
        # nyxt.enable = true;
      };
      education = {
        memorization.enable = true;
        vidcom.enable = false;
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
      distractions.steam.enable = true;
    };
  };

  # KDE-Connect + Start-up indicator
  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent;
  };
}
