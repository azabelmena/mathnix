{
  lib
, autoconf
, automake
, fetchpatch
, fetchurl
, gettext
, gmp
, libtool
, mpfr
, ntl
, openblas
, sphinx
, stdenv
}:
let
  install = "install/flint/";
in
stdenv.mkDerivation rec {
  name = "flint-${version}";
  version = "3.0.1";

  src = fetchurl {
    url = "https://github.com/flintlib/flint/releases/download/v${version}/${name}.tar.gz";
    sha256 = "1d4lawfvmjd4n7rp4z9xkwwjjbrjhkmxnxw1xf0ki1isa001lcbv";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/flintlib/flint/commit/e7d005c369754243cba32bd782ea2a5fc874fde5.diff";
      hash = "sha256-IqEtYEpNVXfoTeerh/0ig+eDqUpAlGdBB3uO8ShYh3o=";
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    libtool
    sphinx
  ];

  propagatedBuildInputs = [
    mpfr
  ];

  buildInputs = [
    gmp
    ntl
    openblas
  ];

  preConfigurePhase = ''
    echo "Executing bootstrap.sh"
    ./bootstrap.sh
    mkdir -p ${install}
  '';

  configureFlags = [
    "--with-gmp=${gmp}"
    "--with-mpfr=${mpfr}"
    "--with-blas=${openblas}"
    "--with-ntl=${ntl}"
    "--prefix=$HOME/mathnix/${install}"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  installPhase = ''
    make install
    make examples
    cd doc && make html && cd ..
  '';

  meta = with lib; {
    description = "Fast Library for Number Theory";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ smasher164 ] ++ teams.sage.members;
    platforms = platforms.unix;
    homepage = "https://www.flintlib.org/";
    downloadPage = "https://www.flintlib.org/downloads.html";
  };
}
