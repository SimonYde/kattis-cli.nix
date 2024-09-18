{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    kattis-cli = {
      url = "github:Kattis/kattis-cli";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      kattis-cli,
    }:
    {

      packages.x86_64-linux.kattis = nixpkgs.legacyPackages.x86_64-linux.callPackage ./kattis.nix {
        inherit kattis-cli;
      };
      packages.x86_64-linux.default = self.packages.x86_64-linux.kattis;
    };
}
