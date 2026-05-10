{
  # cf . https://casualcompute.com/posts/building-a-hugo-website-with-nix/
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    ananke = {
      url = "github:gohugo-ananke/ananke";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, ananke }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        name = "nathan-fouere.com";
        src = self;

        buildPhase = ''
          mkdir -p src/themes/ananke
          cp -r ${inputs.ananke}/* src/themes/ananke/
          ${pkgs.hugo}/bin/hugo --source src
        '';

        installPhase = "cp -r src/public $out";
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.hugo
          pkgs.git
        ];
      };
    };
}
