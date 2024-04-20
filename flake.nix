{
  description = "A flake for Godot 4 VoIP extension";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    godot-cpp = {
      url = "github:godotengine/godot-cpp/48afa82f29354668c12cffaf6a2474dabfd395ed";
      flake = false;
    };
    android.url = "github:tadfisher/android-nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem = { pkgs, system, ... }: let
        androidenv = inputs.android.sdk.x86_64-linux (sdkPkgs: with sdkPkgs; [
          build-tools-34-0-0
          cmdline-tools-latest
          platform-tools
          platforms-android-34
          ndk-23-2-8568313
        ]);
      in rec {
        packages.android = packages.default.overrideAttrs {
          ANDROID_HOME = "${androidenv}/share/android-sdk";
          sconsFlags = [
            "platform=android"
          ];
        };
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

