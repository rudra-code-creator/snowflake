{
  options,
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  options.modules.virtualisation.containers.archlinux = {
    enable = mkEnableOption "arch-linux container";
  };

  config = mkIf config.modules.virtualisation.containers.archlinux.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemuVerbatimConfig = ''
        user = "icy-thought"
      '';
    };

    systemd.nspawn."archLinux" = {
      enable = true;
      wantedBy = [ "machines.target" ];
      requiredBy = [ "machines.target" ];

      execConfig = {
        Timezone = "Bind";
        Hostname = "Arch";
        SystemCallFilter = "modify_ldt";
      };

      filesConfig = {
        Volatile = false;
        BindReadOnly = [ "/home/icy-thought:/mnt/icy-thought" ];
        Bind = [
          "/home/icy-thought/.container-arch:/home/icy-thought"
          "/run/user/1000/wayland-1"
          "/tmp/.X11-unix/X0"
          "/tank"
          "/run/user/1000/pulse/native"
          "/dev/dri"
          "/dev/shm"
        ];
      };

      networkConfig = {
        Private = true;
        VirtualEthernet = true;
        Bridge = "virbr0";
      };
    };

    # Vulkan support
    systemd.services."systemd-nspawn@".serviceConfig = {
      DeviceAllow = [
        "char-drm rwx"
        "/dev/dri/renderD128"
      ];
    };
  };
}
