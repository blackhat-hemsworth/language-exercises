{
  description = "Haskell development environment";

  inputs = {
    # Pinned Nixpkgs repository for reproducible builds
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Helper utilities for system-specific configurations
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};

      haskellPackages = pkgs.haskell.packages.ghc98;

      systemLibs = [
        pkgs.zlib
        pkgs.gmp
      ];
    in {
      devShells.default = pkgs.mkShell {
        name = "haskell-dev-shell";

        # Tools available in the environment
        buildInputs =
          [
            # Haskell Tooling
            haskellPackages.ghc
            haskellPackages.cabal-install
            haskellPackages.haskell-language-server
            pkgs.stack

            # System Build Tools
            pkgs.pkg-config
          ]
          ++ systemLibs;

        # Environment variables to help Stack/Cabal locate system libraries
        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath systemLibs;
        PKG_CONFIG_PATH = pkgs.lib.makeSearchPath "lib/pkgconfig" systemLibs;

        shellHook = ''
          echo "========================================="
          echo " Haskell Development Environment Active "
          echo " GHC:   $(ghc --version)"
          echo " Cabal: $(cabal --version | head -n 1)"
          echo " Stack: $(stack --version | head -n 1)"
          echo "========================================="
        '';
      };
    });
}
