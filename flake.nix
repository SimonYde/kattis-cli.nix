{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
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
    }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      packages = {
        x86_64-linux.kattis-cli = pkgs.callPackage ./kattis-cli.nix {
          inherit kattis-cli;
        };
        x86_64-linux.kattis-test = pkgs.callPackage ./kattis-test.nix {
          inherit kattis-test;
          kattis-cli = self.packages.x86_64-linux.kattis-cli;
        };
        x86_64-linux.default = self.packages.x86_64-linux.kattis-cli;
      };
    };
}
