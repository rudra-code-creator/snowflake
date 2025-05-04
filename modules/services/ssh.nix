{
  options,
  config,
  lib,
  ...
}:

with lib;
{
  options.modules.services.ssh = {
    enable = mkEnableOption "secure-socket shell";
  };

  config = mkIf config.modules.services.ssh.enable {
    services.openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = true;
        PasswordAuthentication = true;
      };

      hostKeys = [
        {
          comment = "rudra@RUCORP-NIXSTATION";
          path = "/etc/ssh/ed25519_key";
          rounds = 100;
          type = "ed25519";
        }
      ];
    };

    user.openssh.authorizedKeys.keyFiles =
      if config.user.name == "rudra" then
        builtins.filter builtins.pathExists [
          "${config.user.home}/.ssh/id_ed25519.pub"
          "${config.user.home}/.ssh/id_rsa.pub"
        ]
      else
        [ ];
  };
}
