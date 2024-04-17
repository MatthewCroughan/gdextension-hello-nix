{
  description = "A flake for Godot 4 VoIP extension";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    gdextension-hello-nix = {
      url = "git+https://github.com/goatchurchprime/gdextension-hello-nix?submodules=1";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, gdextension-hello-nix, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem = { pkgs, ... }: {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "gdextension-hello-nix";
          src = gdextension-hello-nix;
          nativeBuildInputs = [
            pkgs.scons
          ];
          installPhase = ''
            mkdir $out/addons
            mkdir $out/addons/hellonix
            cp addons/hellonix/* $out/addons/hellonix
          '';
        };

        # To hack the code, do:
        #  nix develop
        #  scons
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            scons
            cmake
         ];
        };
      };
    };
}

