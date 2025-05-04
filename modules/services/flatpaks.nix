{
  options,
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  options.modules.services.flatpaks = {
    enable = mkEnableOption "software based KVM switch";
  };

  config = mkIf config.modules.services.flatpaks.enable {
    services = {
      flatpak.enable = true; # Enable Flatpak
    };

    systemd.services.flatpak-repo = {
      wantedBy = ["multi-user.target"];
      path = [pkgs.flatpak];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };

    home.packages = (with pkgs; [
      wine
      bottles
      # The following requires 64-bit FL Studio (FL64) to be installed to a bottle
      # With a bottle name of "FL Studio"
      (pkgs.writeShellScriptBin "flstudio" ''
        #!/bin/sh
        if [ -z "$1" ]
          then
            bottles-cli run -b "FL Studio" -p FL64
            #flatpak run --command=bottles-cli com.usebottles.bottles run -b FL\ Studio -p FL64
          else
            filepath=$(winepath --windows "$1")
            echo \'"$filepath"\'
            bottles-cli run -b "FL Studio" -p "FL64" --args \'"$filepath"\'
            #flatpak run --command=bottles-cli com.usebottles.bottles run -b FL\ Studio -p FL64 -args "$filepath"
          fi
      '')
      (pkgs.makeDesktopItem {
        name = "flstudio";
        desktopName = "FL Studio 64";
        exec = "flstudio %U";
        terminal = false;
        type = "Application";
        icon = "flstudio";
        mimeTypes = ["application/octet-stream"];
      })
      (stdenv.mkDerivation {
        name = "flstudio-icon";
        # icon from https://www.reddit.com/r/MacOS/comments/jtmp7z/i_made_icons_for_discord_spotify_and_fl_studio_in/
        src = [ ./flstudio.png ];

        unpackPhase = ''
          for srcFile in $src; do
            # Copy file into build dir
            cp $srcFile ./
          done
        '';

        installPhase = ''
          mkdir -p $out $out/share $out/share/pixmaps
          ls $src
          ls
          cp $src $out/share/pixmaps/flstudio.png
        '';
      })
      (pkgs.appimageTools.wrapType2 {
        name = "Cura";
        src = fetchurl {
          url = "https://github.com/Ultimaker/Cura/releases/download/5.8.1/UltiMaker-Cura-5.8.1-linux-X64.AppImage";
          hash = "sha256-VLd+V00LhRZYplZbKkEp4DXsqAhA9WLQhF933QAZRX0=";
        };
        extraPkgs = pkgs: with pkgs; [];
      })
      #(pkgs-stable.cura.overrideAttrs (oldAttrs: {
      #  postInstall = oldAttrs.postInstall + ''cp -rf ${(pkgs.makeDesktopItem {
      #      name = "com.ultimaker.cura";
      #      icon = "cura-icon";
      #      desktopName = "Cura";
      #      exec = "env QT_QPA_PLATFORM=xcb ${pkgs-stable.cura}/bin/cura %F";
      #      tryExec = "env QT_QPA_PLATFORM=xcb ${pkgs-stable.cura}/bin/cura";
      #      terminal = false;
      #      type = "Application";
      #      categories = ["Graphics"];
      #      mimeTypes = ["model/stl" "application/vnd.ms-3mfdocument" "application/prs.wavefront-obj"
      #                   "image/bmp" "image/gif" "image/jpeg" "image/png" "text/x-gcode" "application/x-amf"
      #                   "application/x-ply" "application/x-ctm" "model/vnd.collada+xml" "model/gltf-binary"
      #                   "model/gltf+json" "model/vnd.collada+xml+zip"];
      #      })}/share/applications $out/share'';
      #}))
      #(pkgs.writeShellScriptBin "curax" ''env QT_QPA_PLATFORM=xcb ${pkgs-stable.cura}/bin/cura $@'')
      (pkgs.curaengine_stable)
      openscad
      (stdenv.mkDerivation {
        name = "cura-slicer";
        version = "0.0.7";
        src = fetchFromGitHub {
          owner = "Spiritdude";
          repo = "Cura-CLI-Wrapper";
          rev = "ff076db33cfefb770e1824461a6336288f9459c7";
          sha256 = "sha256-BkvdlqUqoTYEJpCCT3Utq+ZBU7g45JZFJjGhFEXPXi4=";
        };
        phases = "installPhase";
        installPhase = ''
          mkdir -p $out $out/bin $out/share $out/share/cura-slicer
          cp $src/cura-slicer $out/bin
          cp $src/settings/fdmprinter.def.json $out/share/cura-slicer
          cp $src/settings/base.ini $out/share/cura-slicer
          sed -i 's+#!/usr/bin/perl+#! /usr/bin/env nix-shell\n#! nix-shell -i perl -p perl538 perl538Packages.JSON+g' $out/bin/cura-slicer
          sed -i 's+/usr/share+/home/rudra/.nix-profile/share+g' $out/bin/cura-slicer
        '';
        propagatedBuildInputs = with pkgs; [
          curaengine_stable
        ];
      })
      obs-studio
      ffmpeg
      (pkgs.writeScriptBin "kdenlive-accel" ''
        #!/bin/sh
        DRI_PRIME=0 kdenlive "$1"
      '')
      # Various dev packages
      remmina
      sshfs
      texinfo
      libffi zlib
      nodePackages.ungit
      ventoy
      kdePackages.kdenlive
    ]);
  };
}
