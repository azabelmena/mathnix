{

  description = "Nix Flakes for Mathematics";

  inputs = {
    nixpkgs.url = "github:azabelmena/nixpkgs/math";
};

outputs = { self, nixpkgs }:
let
  system = "x86_64-linux";

  pkgs = nixpkgs.legacyPackages.${system};
in
  {

    devShells.${system} = {
      mathnix = pkgs.mkShell{
        name = "MathNix";

        nativeBuildInputs = [
          pkgs.autoconf
          pkgs.automake
          pkgs.coreutils
          pkgs.flint3
          pkgs.gcc
          pkgs.gdb
          pkgs.gettext
          pkgs.glibc
          pkgs.gnumake
          pkgs.libtool
          pkgs.python3
          pkgs.sage
          pkgs.singular
        ];

        LDPC_LIB = "${pkgs.callPackage ./derivations/ldpc.nix {} }/LDPC-library";
        LDPC = "${pkgs.callPackage ./derivations/ldpc.nix {} }/LDPC-codes";

        NIX_CFLAGS_COMPILE = ''
          -O3
          -g
          -lflint
          -lgmp
          -lmpfr
        '';
      };
    };
  };
}
