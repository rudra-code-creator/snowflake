{
  description = "λ simple and configureable Nix-Flake repository!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # System application(s)
    ragenix.url = "github:yaxitech/ragenix";
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Window Manager(s) + Extensions
    xmonad = {
      url = "github:xmonad/xmonad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xmonad-contrib.url = "github:icy-thought/xmonad-contrib"; # :TODO| replace with official after #582 == merged!
    pyprland.url = "github:hyprland-community/pyprland";

    # Application -> (Cached) Git
    emacs.url = "github:nix-community/emacs-overlay";
    rust.url = "github:oxalica/rust-overlay";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # Submodules (temporary) # TODO
    emacs-dir = {
      type = "git";
      url = "https://codeberg.org/Icy-Thought/emacs.d.git";
      submodules = true;
      flake = false;
    };
    nvim-dir = {
      type = "git";
      url = "https://codeberg.org/Icy-Thought/nvim.d.git";
      submodules = true;
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-index-database,
      ...
    }:
    let
      inherit (lib) my;
      system = "x86_64-linux";

      mkPkgs =
        pkgs: extraOverlays:
        import pkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = extraOverlays ++ (lib.attrValues self.overlays);
        };
      pkgs = mkPkgs nixpkgs [ self.overlays.default ];

      lib = nixpkgs.lib.extend (
        final: prev: {
          my = import ./lib {
            inherit pkgs inputs;
            lib = final;
          };
        }
      );
    in
    {
      lib = lib.my;

      overlays = (my.mapModules ./overlays import) // {
        default = final: prev: {
          my = self.packages.${system};
        };

        nvfetcher = final: prev: {
          sources = builtins.mapAttrs (_: p: p.src) (
            (import ./packages/_sources/generated.nix) {
              inherit (final)
                fetchurl
                fetchgit
                fetchFromGitHub
                dockerTools
                ;
            }
          );
        };
      };

      packages."${system}" = my.mapModules ./packages (p: pkgs.callPackage p { });

      nixosModules = {
        snowflake = import ./.;
      } // my.mapModulesRec ./modules import;

      nixosConfigurations = my.mapHosts ./hosts { };

      devShells."${system}".default = import ./shell.nix { inherit lib pkgs; };

      templates.full = {
        path = ./.;
        description = "λ well-tailored and configureable NixOS system!";
      } // import ./templates;

      templates.default = self.templates.full;

      # TODO: deployment + template tool.
      # apps."${system}" = {
      #   type = "app";
      #   program = ./bin/hagel;
      # };
    };
}
