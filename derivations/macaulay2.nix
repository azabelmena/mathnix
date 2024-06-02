{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  name = "Macaulay2";

  src = pkgs.fetchFromGitHub {
    owner = "Macaulay2";
    repo = "M2";
    rev = "ec65028f1527076b663279b1311188caa9e22b67";
    sha256 = "1k9ij2gs8vvjdxw0qzfznnn330n49waf8hlybfwazha07ykmygdq";
    fetchSubmodules = true;
  };

  nativeBuildInputs = with pkgs; [
    autoreconfHook
    emacs
    bison
    curl
    gcc
    gfortran
    git
    gmp
    gnumake
    libffi
    libtool
    libxml2
    lzma
    mpfr
    pkg-config
    wget
  ];

  buildInputs = with pkgs; [
    blas
    boehmgc
    boost
    eigen
    flint
    givaro
    ncurses
    tbb
  ];

  autoreconfPhase = ''
    cd M2/
    make

  '';

  configureFlags = [
    "--with-boost-libdir=${pkgs.boost}/lib"
    "--enable-downloads"
  ];

  configurePhase = ''
    ./configure $configureFlags
  '';

  doParallelBuild = true;
  doCheck = true;

  installPhase = ''
    echo "Installing!"
    mkdir -p $out/

    cp -rf * $out/
  '';
}
