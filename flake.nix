{

  description = "Nix Flakes for Mathematics";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
};

outputs = { self, nixpkgs }:
let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};

in
  {
    devShells.${system} = {
      ffal = pkgs.mkShell{
        name = "FFAL";


        nativeBuildInputs = with pkgs; [
          autoconf
          automake
          coreutils
          flint3
          gcc
          gdb
          gettext
          glibc
          gmp
          gnumake
          libtool
          mpfr
          ntl
          ntl
          openblas
          openblas
          python3
          sage
          singular
        ];

        ldpc = pkgs.callPackage ./derivations/ldpc.nix {};
        macaulay2 = pkgs.callPackage ./derivations/macaulay2.nix {};

        NIX_CFLAGS_COMPILE = ''
          -O3
          -lflint
          -lgmp
          -lmpfr
        '';
      };
    };

  };
}
