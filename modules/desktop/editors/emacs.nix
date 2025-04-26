{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.modules.desktop.editors.emacs;
in
with lib;
{
  options.modules.desktop.editors.emacs = {
    enable = mkEnableOption "Sprinkle a bit of magic to the nix-flake.";
    package = mkOption {
      description = "Emacs version to be installed.";
      type = types.package;
      default =
        if (config.modules.desktop.session.type == "wayland") then pkgs.emacs-pgtk else pkgs.emacs-git;
    };
    terminal = mkOption {
      description = "Terminal emulator to be installed in Emacs.";
      type = types.nullOr (
        types.enum [
          "Eat"
          "VTerm"
        ]
      );
      default = "Eat";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.emacs.overlay ];

    user.packages =
      with pkgs;
      [
        binutils
        gnutls
        zstd
        graphviz # org-roam (graph)
        my.my-cookies # leetcode
        my.tgs2png
      ]
      ++ optionals config.programs.gnupg.agent.enable [ pinentry-emacs ];
    environment.wordlist.enable = true; # cape-dict
    home.sessionVariables.TDLIB_PREFIX = "${pkgs.tdlib}"; # telega

    hm.programs.emacs = {
      enable = true;
      package = cfg.package;
      extraPackages =
        epkgs:
        with epkgs;
        [
          mu4e
          melpaPackages.jinx
          treesit-grammars.with-all-grammars
        ]
        ++ optionals (cfg.terminal == "VTerm") [ melpaPackages.vterm ];

    };

    hm.services.emacs = {
      enable = true;
      client = {
        enable = true;
        arguments = [
          "--create-frame"
          "--no-wait"
        ];
      };
      socketActivation.enable = true;
    };

    hm.programs.zsh.initExtra =
      ''
        # -------===[ Useful Functions ]===------- #
        ediff()  { emacsclient -c -a \'\' --eval "(ediff-files \"$1\" \"$2\")"; }
        edired() { emacsclient -c -a \'\' --eval "(progn (dired \"$1\"))"; }
        ekill()  { emacsclient -c -a \'\' --eval '(kill-emacs)'; }
        eman()   { emacsclient -c -a \'\' --eval "(switch-to-buffer (man \"$1\"))"; }
        magit()  { emacsclient -c -a \'\' --eval '(magit-status)'; }
      ''
      + optionalString (cfg.terminal == "Eat") ''
        # -------===[ EAT Integration ]===------- #
        if [ -n "$EAT_SHELL_INTEGRATION_DIR" ]; then
          source "$EAT_SHELL_INTEGRATION_DIR/zsh"
        fi
      ''
      + optionalString (cfg.terminal == "VTerm") ''
        # -------===[ VTerm Integration ]===------- #
        function vterm_printf(){
           if [ -n "$TMUX" ] && ([ "''${TERM%%-*}" = "tmux" ] || [ "''${TERM%%-*}" = "screen" ] ); then
               # Tell tmux to pass the escape sequences through
               printf "\ePtmux;\e\e]%s\007\e\\" "$1"
           elif [ "''${TERM%%-*}" = "screen" ]; then
               # GNU screen (screen, screen-256color, screen-256color-bce)
               printf "\eP\e]%s\007\e\\" "$1"
           else
               printf "\e]%s\e\\" "$1"
           fi
        }
      '';

    hm.programs.fish = {
      functions = {
        ediff = "emacsclient -c -a '' --eval \"(ediff-files '$argv[1]' '$argv[2]')\"";
        edired = "emacsclient -c -a '' --eval \"(progn (dired '$argv[1]'))\"";
        ekill = "emacsclient -c -a '' --eval '(kill-emacs)'";
        eman = "emacsclient -c -a '' --eval \"(switch-to-buffer (man '$argv[1]'))\"";
        magit = " emacsclient -c -a '' --eval '(magit-status)'";
      };

      interactiveShellInit =
        optionalString (cfg.terminal == "Eat") ''
          # -------===[ EAT Integration ]===------- #
          if status is-interactive; and test "$EAT_SHELL_INTEGRATION_DIR"
              source $EAT_SHELL_INTEGRATION_DIR/fish
          end
        ''
        + optionalString (cfg.terminal == "VTerm") ''
          # -------===[ VTerm Integration ]===------- #
          function vterm_printf;
               if begin; [  -n "$TMUX" ]  ; and  string match -q -r "screen|tmux" "$TERM"; end
                   # tell tmux to pass the escape sequences through
                   printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
               else if string match -q -- "screen*" "$TERM"
                   # GNU screen (screen, screen-256color, screen-256color-bce)
                   printf "\eP\e]%s\007\e\\" "$argv"
               else
                   printf "\e]%s\e\\" "$argv"
               end
           end
        '';
    };

    create.configFile = {
      early-init = {
        target = "emacs/early-init.el";
        source = "${inputs.emacs-dir}/early-init.el";
      };
      init = {
        target = "emacs/init.el";
        source = "${inputs.emacs-dir}/init.el";
      };
    };
  };
}
