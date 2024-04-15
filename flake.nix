{

  # nix build -L --builders 'ssh-ng://nix-ssh@100.107.23.115 x86_64-linux,i686-linux - 16 - big-parallel'

  description = "A flake for Godot 4 VoIP extension";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    gdextension-hello-nix = {
      url = "git+https://github.com/goatchurchprime/gdextension-hello-nix?submodules=1";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
  };
  
  outputs = { nixpkgs, flake-utils, gdextension-hello-nix, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
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
      });
}

