let
  pinnedPkgs = import (builtins.fetchTarball {
    # nixos-24.05, last revision with haskell.compiler.ghc928
    url = "https://github.com/NixOS/nixpkgs/archive/b134951a4c9f3c995fd7be05f3243f8ecd65d798.tar.gz";
    sha256 = "0zydsqiaz8qi4zd63zsb2gij2p614cgkcaisnk11wjy3nmiq0x1s";
  }) {};
  ghc = pinnedPkgs.haskell.compiler.ghc928;
  systemLibs = with pinnedPkgs; [ zlib sqlite ];
in
pinnedPkgs.mkShell {
  name = "haskell-mooc-env";
  buildInputs = [ ghc pinnedPkgs.stack pinnedPkgs.git pinnedPkgs.cacert ] ++ systemLibs;
  LD_LIBRARY_PATH = pinnedPkgs.lib.makeLibraryPath systemLibs;
}
