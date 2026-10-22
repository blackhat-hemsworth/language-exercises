{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    zig-overlay.url = "github:mitchellh/zig-overlay";
    zls-overlay.url = "github:zigtools/zls";
  };

  outputs = {
    self,
    nixpkgs,
    zig-overlay,
    zls-overlay,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSystem = nixpkgs.lib.genAttrs systems;
  in {
    devShells = forEachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      # Target a specific Zig version (e.g., "0.13.0" or "master")
      zigPkg = zig-overlay.packages.${system}.master;
      zlsPkg = zls-overlay.packages.${system}.zls;
    in {
      default = pkgs.mkShell {
        packages = [
          zigPkg
          zlsPkg
        ];
      };
    });
  };
}
