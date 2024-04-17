{
  description = "A flake for Godot 4 VoIP extension";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    godot-cpp = {
      url = "github:godotengine/godot-cpp/48afa82f29354668c12cffaf6a2474dabfd395ed";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem = { pkgs, ... }: {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "gdextension-hello-nix";
          src = inputs.self;
          prePatch = ''
            cp -r --no-preserve=mode ${inputs.godot-cpp} ./godot-cpp
          '';
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

