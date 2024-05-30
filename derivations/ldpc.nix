{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  name = "LDPC";

  src = pkgs.fetchFromGitHub {
    owner = "shubhamchandak94";
    repo = "ProtographLDPC";
    rev = "0fe057a58d94a2c1f8599c6718e24a027113818c";
    sha256 = "0rdjr1lza5pz7p6cr495c2pilm646k8bhhib8gd92dzrwp3ksg7q";
    fetchSubmodules = true;
  };

  installPhase = ''
    echo "Building!"
    mkdir -p $out

    cp -rf * $out/

    cd $out/LDPC-codes

    make

    cd $out/peg

    make

  '';
}
