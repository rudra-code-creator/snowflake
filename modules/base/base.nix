{
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  managed-firefox = (pkgs.firefox.override {
    extraPolicies = {
      AutofillCreditCardEnabled = false;
      DisableFirefoxAccounts = true;
      DisableFirefoxScreenshots = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };
      ExtensionSettings = {
        "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
        # 1Password:
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        # Facebook container
        "@contain-facebook" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/facebook-container/latest.xpi";
          installation_mode = "force_installed";
        };
        # LeechBlockNG
        "leechblockng@proginosko.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/leechblock-ng/latest.xpi";
          installation_mode = "force_installed";
        };
        # ublock origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };

      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };
      PasswordManagerEnabled = false;
      PictureInPicture = {
        Enabled = true;
        Locked = true;
      };
    };
  });
in
with lib;
{
  options.modules.base = {
    enable = mkEnableOption "BASE miscellaneous config";
  };

  config = mkIf config.modules.base.enable {
    # BASE miscellaneous config
    user.packages = with pkgs; [ 
      pipeline 
      switcheroo 
      switcheroo-control 
      flightgear 
      kicad 
      gnome-extension-manager 
      waynergy 
      fdroidserver 
      fdroidcl 
      libreoffice-qt6-fresh 
      converseen
      resources
      mcontrolcenter # Tool to change the settings of MSI laptops running Linux
      gnome-control-center
      mission-center
      lact
      gearlever
      geary
      clever-tools
      toolbox
      #steamos-devkit
      devtoolbox
      clapgrep
    ];
    environment.systemPackages = [ managed-firefox ];

    services.opensnitch.rules = {
      rule-000-firefox = {
        name = "Allow Firefox";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin managed-firefox}/lib/firefox/firefox";
        };
      };
    };
  };
}