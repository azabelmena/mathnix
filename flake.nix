{

  description = "Nix Flakes for Mathematics";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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

        nativeBuildInputs = with pkgs; [
          autoconf
          automake
          coreutils
          flint
          gcc
          gdb
          gettext
          glibc
          gnumake
          libtool
          macaulay2
          python3
          sageWithDoc
          singular
        ];

        LDPC_LIB = "${pkgs.callPackage ./ldpc.nix {} }/LDPC-library";
        LDPC = "${pkgs.callPackage ./ldpc.nix {} }/LDPC-codes";

        SAGEDOC = "${pkgs.sageWithDoc.doc}/share/doc/sage/html/en/index.html";

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
