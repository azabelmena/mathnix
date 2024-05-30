{

  description = "Nix Flakes for Mathematics";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
};

outputs = { self, nixpkgs }:
let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};

in
  {
    packages.${system}.default = ( import ./derivations/flint2.nix { inherit pkgs ; } );

    devShells.${system} = {
      ffal = pkgs.mkShell{
        name = "FFAL";


        nativeBuildInputs = with pkgs; [
          autoconf
          openblas
          ntl
          automake
          coreutils
          gcc
          gdb
          gettext
          openblas
          ntl
          glibc
          gmp
          gnumake
          libtool
          mpfr
          python3
          sage
        ];

        flint = pkgs.callPackage ./derivations/flint.nix {};
        ldpc = pkgs.callPackage ./derivations/ldpc.nix {};

        NIX_CFLAGS_COMPILE = ''
          -O3
          -lgmp
          -lmpfr
          -I${pkgs.callPackage ./derivations/flint.nix {}}/include/
          -L${pkgs.callPackage ./derivations/flint.nix {}}/lib/
        '';
      };
    };

  };
}
