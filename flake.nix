{

  description = "Nix Flakes for Mathematics";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
    macaulay.url = "github:alois31/nixpkgs/macaulay2";
};

outputs = { self, nixpkgs, macaulay }:
let
  system-x86_64-linux = "x86_64-linux";
  system-aarch64-darwin = "aarch64-darwin";

  pkgs-x86_64-linux = nixpkgs.legacyPackages.${system-x86_64-linux};
  m2-x86_64-linux = macaulay.legacyPackages.${system-x86_64-linux};

  pkgs-aarch64-darwin = nixpkgs.legacyPackages.${system-aarch64-darwin};
  m2-aarch64-darwin = macaulay.legacyPackages.${system-aarch64-darwin};
in
  {

    devShells.${system-x86_64-linux} = {
      mathnix = pkgs-x86_64-linux.mkShell{
        name = "MathNix";

        nativeBuildInputs = [
          pkgs-x86_64-linux.autoconf
          pkgs-x86_64-linux.automake
          pkgs-x86_64-linux.coreutils
          pkgs-x86_64-linux.flint3
          pkgs-x86_64-linux.gcc
          pkgs-x86_64-linux.gdb
          pkgs-x86_64-linux.gettext
          pkgs-x86_64-linux.glibc
          pkgs-x86_64-linux.gnumake
          pkgs-x86_64-linux.libtool
          pkgs-x86_64-linux.python3
          pkgs-x86_64-linux.sage
          pkgs-x86_64-linux.singular
          m2-x86_64-linux.macaulay2
        ];

        LDPC_LIB = "${pkgs-x86_64-linux.callPackage ./derivations/ldpc.nix {} }/LDPC-library";
        LDPC = "${pkgs-x86_64-linux.callPackage ./derivations/ldpc.nix {} }/LDPC-codes";

        NIX_CFLAGS_COMPILE = ''
          -O3
          -g
          -lflint
          -lgmp
          -lmpfr
        '';
      };
    };

    devShells.${system-aarch64-darwin} = {
      mathnix = pkgs-aarch64-darwin.mkShell{
        name = "MathNix";

        nativeBuildInputs = [
          pkgs-aarch64-darwin.autoconf
          pkgs-aarch64-darwin.automake
          pkgs-aarch64-darwin.coreutils
          pkgs-aarch64-darwin.flint3
          pkgs-aarch64-darwin.gcc
          pkgs-aarch64-darwin.gdb
          pkgs-aarch64-darwin.gettext
          pkgs-aarch64-darwin.glibc
          pkgs-aarch64-darwin.gnumake
          pkgs-aarch64-darwin.libtool
          pkgs-aarch64-darwin.python3
          pkgs-aarch64-darwin.sage
          pkgs-aarch64-darwin.singular
          m2-aarch64-darwin.macaulay2
        ];

        LDPC_LIB = "${pkgs-aarch64-darwin.callPackage ./derivations/ldpc.nix {} }/LDPC-library";
        LDPC = "${pkgs-aarch64-darwin.callPackage ./derivations/ldpc.nix {} }/LDPC-codes";

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
