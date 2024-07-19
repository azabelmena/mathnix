{

  description = "Nix Flakes for Mathematics";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
    macaulay.url = "github:alois31/nixpkgs/macaulay2";
};

outputs = { self, nixpkgs, macaulay }:
let
  system = "x86_64-linux";

  pkgs = nixpkgs.legacyPackages.${system};
  m2 = macaulay.legacyPackages.${system};
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
          m2.macaulay2
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
