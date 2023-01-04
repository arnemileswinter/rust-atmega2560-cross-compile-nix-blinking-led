{
  inputs = {
    fenix.url = "github:nix-community/fenix";
    ravedude.url = "github:Rahix/avr-hal?dir=ravedude";
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs, ravedude, fenix }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
            pkgs.pkgsCross.avr.buildPackages.gcc
            pkgs.pkgsCross.avr.buildPackages.binutils
            ravedude.defaultPackage.${system}
            (fenix.packages.${system}.fromToolchainFile {
              file = ./rust-toolchain.toml;
              sha256 = "sha256-Y2DBRMR6w4fJu+jwplWInTBzNtbr0EW3yZ3CN9YTI/8=";
            })
        ];
      };
    };
}
