{
  options,
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  options.modules.develop.jetbrains = {
    enable = mkEnableOption "Jetbrains development";
  };

  config = mkIf config.modules.develop.jetbrains.enable (mkMerge [
    {
      user.packages = with pkgs.jetbrains; [
        writerside
        webstorm
        rust-rover
        ruby-mine
        rider
        pycharm-professional
        pycharm-community-bin
        phpstorm
        mps
        jdk
        jcef
        idea-ultimate
        idea-community-bin
        goland
        gateway
        dataspell
        datagrip
        clion
        aqua
      ];

      services.opensnitch.rules = {
        rule-500-jetbrains-to-jetbrains = {
          name = "Allow Jetbrains tools to phone home";
          enabled = true;
          action = "allow";
          duration = "always";
          operator = {
            type = "list";
            operand = "list";
            list = [
              {
                type = "simple";
                sensitive = false;
                operand = "process.path";
                data = idePath;
              }
              {
                type = "regexp";
                operand = "dest.host";
                sensitive = false;
                data = "^([a-z0-9|-]+\\.)*jetbrains\\.com$";
              }
            ];
          };
        };
        rule-500-jetbrains-to-github = {
          name = "Allow Jetbrains tools to reach GitHub";
          enabled = true;
          action = "allow";
          duration = "always";
          operator = {
            type = "list";
            operand = "list";
            list = [
              {
                type = "simple";
                sensitive = false;
                operand = "process.path";
                data = idePath;
              }
              {
                type = "regexp";
                operand = "dest.host";
                sensitive = false;
                data = "^(github\\.com|raw\\.githubusercontent\\.com)$";
              }
            ];
          };
        };
        rule-500-jetbrains-to-npm = {
          name = "Allow Jetbrains tools to contact npm";
          enabled = true;
          action = "allow";
          duration = "always";
          operator = {
            type = "list";
            operand = "list";
            list = [
              {
                type = "simple";
                sensitive = false;
                operand = "process.path";
                data = idePath;
              }
              {
                type = "simple";
                operand = "dest.host";
                sensitive = false;
                data = "registry.npmjs.org";
              }
            ];
          };
        };
        rule-500-jetbrains-to-schemastore = {
          name = "Allow Jetbrains tools to reach schemastore";
          enabled = true;
          action = "allow";
          duration = "always";
          operator = {
            type = "list";
            operand = "list";
            list = [
              {
                type = "simple";
                sensitive = false;
                operand = "process.path";
                data = idePath;
              }
              {
                type = "regexp";
                operand = "dest.host";
                sensitive = false;
                data = "^([a-z0-9|-]+\\.)*schemastore\\.org$";
              }
            ];
          };
        };
        rule-500-jetbrains-to-pypi = {
          name = "Allow Jetbrains tools to reach out to pypi";
          enabled = true;
          action = "allow";
          duration = "always";
          operator = {
            type = "list";
            operand = "list";
            list = [
              {
                type = "simple";
                sensitive = false;
                operand = "process.path";
                data = idePath;
              }
              {
                type = "regexp";
                operand = "dest.host";
                sensitive = false;
                data = "^pypi.python.org|pypi.org$";
              }
            ];
          };
        };
      };
    }

    (mkIf config.modules.develop.xdg.enable {
      # TODO:
    })
  ]);
}
