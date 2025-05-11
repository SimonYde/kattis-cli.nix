{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    kattis-cli = {
      url = "github:Kattis/kattis-cli";
      flake = false;
    };
    kattis-test = {
      url = "github:tyilo/kattis-test";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      kattis-cli,
      kattis-test,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = self.packages.${system}.kattis-cli;

        packages.kattis-cli = pkgs.callPackage ./nix/kattis-cli.nix {
          inherit kattis-cli;
        };

        packages.kattis-test = pkgs.callPackage ./nix/kattis-test.nix {
          inherit kattis-test;
          kattis-cli = self.packages.${system}.kattis-cli;
        };
      }
    );

}
