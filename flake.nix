{
  description = "Basic rpi pico development shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/master";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: 
    let
      pico-sdk-w-submodules = with pkgs; (pico-sdk.overrideAttrs (o:
        rec {
        pname = "pico-sdk";
        version = "2.2.0";
        src = fetchFromGitHub {
          fetchSubmodules = true;
          owner = "raspberrypi";
          repo = pname;
          rev = version;
          sha256 = "sha256-8ubZW6yQnUTYxQqYI6hi7s3kFVQhe5EaxVvHmo93vgk=";
        };
        }));
      pkgs = nixpkgs.legacyPackages.${system};
    in {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            pico-sdk-w-submodules
            cmake
            clang-tools
            gcc-arm-embedded
            ];
          shellHook = ''
            export PICO_SDK_PATH="${pico-sdk-w-submodules}/lib/pico-sdk"
            '';
          };
      });
}
