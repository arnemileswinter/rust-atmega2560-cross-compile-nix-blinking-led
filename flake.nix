{
  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        LD_LIBRARY_PATH = "${pkgs.pkgsCross.avr.avrlibc}/avr/lib";
        buildInputs = 
            (with pkgs.pkgsCross.avr; [
              buildPackages.gcc
              buildPackages.bintools
              buildPackages.binutils
              avrlibc
            ]) ++ [
            ravedude.defaultPackage.${system}
            (with fenix.packages.${system}; combine [
              minimal.cargo
              minimal.rustc
              latest.rust-src
            ])
          ];
      };
    };
}
