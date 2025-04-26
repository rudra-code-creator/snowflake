{
  options,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.desktop.toolset.communication;
  mailDir = "${config.hm.xdg.dataHome}/mail";
in
with lib;
{
  options.modules.desktop.toolset.communication = with types; {
    base.enable = mkEnableOption "cross-platform clients";
    mu4e.enable = mkEnableOption "a full-featured e-mail client";
    discord.enable = mkEnableOption "discord client" // {
      default = cfg.base.enable;
    };
    matrix = {
      enable = mkEnableOption "Chat clients that utilizes the matrix protocol";
      default = mkOption {
        type = enum [
          "client"
          "daemon"
        ];
        default = "daemon";
        description = "Matrix client type which will be installed & setup";
      };

    };
  };

  config = mkMerge [
    (mkIf cfg.base.enable { user.packages = [ pkgs.signal-desktop ]; })

    (mkIf cfg.mu4e.enable {
      hm.accounts.email = {
        maildirBasePath = mailDir;
        accounts.${config.user.name} =
          let
            mailAddr = "IcyThought@disroot.org";
          in
          {
            realName = "${config.user.name}";
            userName = "${mailAddr}";
            address = "${mailAddr}";
            passwordCommand = "cat /run/agenix/mailingQST";
            primary = true;

            flavor = "plain";
            imap = {
              host = "disroot.org";
              port = 993;
            };
            smtp = {
              host = "disroot.org";
              port = 465;
            };
            gpg = {
              key = "2E690B8644FE29D8237F6C42B593E438DDAB3C66";
              encryptByDefault = false;
              signByDefault = true;
            };
            mbsync = {
              enable = true;
              create = "both";
              expunge = "both";
              patterns = [ "*" ];
            };
            msmtp = {
              enable = true;
              extraConfig.auth = "login";
            };
            mu.enable = true;
          };
      };

      hm.programs = {
        mbsync.enable = true;
        msmtp.enable = true;
        mu.enable = true;
      };
    })

    (mkIf cfg.matrix.enable (mkMerge [
      (mkIf (cfg.matrix.default == "daemon") {
        hm.nixpkgs = {
          # :WARN| TEMPORARY/INSECURE SOLUTION...
          config.permittedInsecurePackages = [ "olm-3.2.16" ];
        };

        hm.services.pantalaimon = {
          enable = true;
          settings = {
            Default = {
              LogLevel = "Debug";
              SSL = true;
            };
            local-matrix = {
              Homeserver = "https://matrix.org";
              ListenAddress = "localhost";
              ListenPort = 8009;
              IgnoreVerification = true;
              UseKeyring = false;
            };
          };
        };
      })

      (mkIf (cfg.matrix.default == "client") {
        user.packages = with pkgs; [
          (symlinkJoin {
            name = "element-desktop-in-dataHome";
            paths = [ element-desktop ];
            nativeBuildInputs = [ makeWrapper ];
            postBuild = ''
              wrapProgram "$out/bin/element-desktop" \
                --add-flags '--profile-dir $XDG_DATA_HOME/Element'
            '';
          })
        ];
      })
    ]))

    (mkIf cfg.discord.enable { user.packages = [ pkgs.vesktop ]; })
  ];
}
