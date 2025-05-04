{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

with lib;
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
      "discard"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "usbhid"
      "uas"
      "sd_mod"
      "rtsx_pci_sdmmc"
    ];
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "pcie_aspm=performance"
      "pci=pcie_bus_perf"
      "mitigations=off" # Significant performance boost, not multi-user.
    ];
  };

  hardware.cpu.amd.updateMicrocode = true;
  powerManagement.cpuFreqGovernor = "performance";

  # Recommended, define logical cores manually
  nix.settings.max-jobs = mkDefault 4;

  # Manage device power-control:
  services.power-profiles-daemon.enable = true;

  # Finally, our beloved hardware module(s):
  modules.hardware = {
    plymouth.enable = true;
    pipewire.enable = true;
    bluetooth.enable = true;
    kmonad.deviceID = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
    pointer.enable = true;
    printer.enable = true;
  };

  services = {
    upower.enable = true;
    libinput.touchpad = {
      accelSpeed = "0.5";
      accelProfile = "adaptive";
    };
  };
}
