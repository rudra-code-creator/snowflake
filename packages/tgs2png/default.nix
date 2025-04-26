{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  libpng,
  rlottie,
}:

stdenv.mkDerivation {
  name = "tgs2png";
  src = fetchFromGitHub {
    owner = "zevlg";
    repo = "tgs2png";
    rev = "25c15b7c2ca3b1a580a383d9d3cb13bf8531d04a";
    hash = "sha256-1FdSX/vLyAFoiYHsuzh6gNeWjbAmzWnBTnm7edXfVTE";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    libpng
    rlottie
  ];

  buildPhase = ''
    cmake
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp tgs2png $out/bin
  '';

  meta = with lib; {
    description = "Convert Telegram's animated stickers -> PNG images";
    homepage = "https://github.com/zevlg/tgs2png";
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
}
