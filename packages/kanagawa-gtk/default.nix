{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk-engine-murrine,
  sassc,
  accent ? [ "default" ],
  shade ? "dark",
  size ? "standard",
}:

let
  validAccents = [
    "default"
    "purple"
    "pink"
    "red"
    "orange"
    "yellow"
    "green"
    "teal"
    "grey"
  ];
  validShades = [
    "light"
    "dark"
  ];
  validSizes = [
    "standard"
    "compact"
  ];

  single = x: lib.optional (x != null) x;
  pname = "Kanagawa";
in
lib.checkListOfEnum "${pname} Valid theme accent(s)" validAccents accent lib.checkListOfEnum
  "${pname} Valid shades"
  validShades
  (single shade)
  lib.checkListOfEnum
  "${pname} Valid sizes"
  validSizes
  (single size)

  stdenv.mkDerivation
  {
    pname = "kanagawa-gtk";
    version = "unstable-2025-04-23";

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Kanagawa-GKT-Theme";
      rev = "c8853b8c2308db51b427b1f9d175a906a43dd6fe";
      hash = "sha256-TD08N9sCgQtjFQlreIosg2cgaj7hY4nNGYpwm760Ios=";
    };

    nativeBuildInputs = [ sassc ];

    propagatedUserEnvPkgs = [ gtk-engine-murrine ];

    postPatch = ''
      find -name "*.sh" -print0 | while IFS= read -r -d ''' file; do
        patchShebangs "$file"
      done
    '';

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/{icons,themes}

      ./themes/install.sh \
        --name ${pname} \
        ${toString (map (x: "--theme " + x) accent)} \
        ${lib.optionalString (shade != null) ("--color " + shade)} \
        ${lib.optionalString (size != null) ("--size " + size)} \
        --dest $out/share/themes

      cp -r $src/icons/Kanagawa $out/share/icons

      runHook postInstall
    '';

    meta = with lib; {
      description = "A GTK theme based on the Kanagawa colour palette";
      homepage = "https://github.com/Fausto-Korpsvart/Kanagawa-GTK-Theme";
      license = licenses.gpl3Only;
      # maintainers = [ icy-thought ];
      platforms = platforms.all;
    };
  }
