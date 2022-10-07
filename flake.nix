{
  description = "A libadwaita wrapper for ExpidusOS with Tokyo Night's styling";

  inputs.vadi = {
    url = github:ExpidusOS/Vadi/feat/nix;
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.ntk = {
    url = path:subprojects/ntk;
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.expidus-sdk = {
    url = github:ExpidusOS/sdk;
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, vadi, ntk, expidus-sdk }:
    let
      supportedSystems = [
        "aarch64-linux"
        "i686-linux"
        "riscv64-linux"
        "x86_64-linux"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
      src = self // { submodules = true; };
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          vadi-pkg = vadi.packages.${system}.default;
          ntk-pkg = ntk.packages.${system}.default;
          expidus-sdk-pkg = expidus-sdk.packages.${system}.default;

          mkDerivation = ({ name, buildInputs, mesonFlags ? [] }: pkgs.stdenv.mkDerivation rec {
            inherit name buildInputs src mesonFlags;

            outputs = [ "out" "dev" "devdoc" ];

            enableParallelBuilding = true;
            nativeBuildInputs = with pkgs; [ meson ninja pkg-config vala glib sass nodejs expidus-sdk-pkg ];

            meta = with pkgs.lib; {
              homepage = "https://github.com/ExpidusOS/libtokyo";
              license = with licenses; [ gpl3Only ];
              maintainers = [ "Tristan Ross" ];
            };
          });
        in {
          default = mkDerivation {
            name = "libtokyo";
            mesonFlags = ["-Dntk=enabled" "-Dgtk4=enabled" "-Dgtk3=enabled" "-Dnodejs=disabled"];
            buildInputs = with pkgs; [ vadi-pkg gtk3 libhandy gtk4 libadwaita ntk-pkg ];
          };

          gtk3 = mkDerivation {
            name = "libtokyo-gtk3";
            mesonFlags = ["-Dntk=disabled" "-Dgtk4=disabled" "-Dgtk3=enabled" "-Dnodejs=disabled"];
            buildInputs = with pkgs; [ vadi-pkg gtk3 libhandy ];
          };

          gtk4 = mkDerivation {
            name = "libtokyo-gtk4";
            mesonFlags = ["-Dntk=disabled" "-Dgtk4=enabled" "-Dgtk3=disabled" "-Dnodejs=disabled"];
            buildInputs = with pkgs; [ vadi-pkg gtk4 libadwaita ];
          };

          ntk = mkDerivation {
            name = "libtokyo-ntk";
            mesonFlags = ["-Dntk=enabled" "-Dgtk4=disabled" "-Dgtk3=disabled" "-Dnodejs=disabled"];
            buildInputs = with pkgs; [ vadi-pkg ntk-pkg ];
          };
        });

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          vadi-pkg = vadi.packages.${system}.default;
          ntk-pkg = ntk.packages.${system}.default;
          expidus-sdk-pkg = expidus-sdk.packages.${system}.default;
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              meson
              ninja
              pkg-config
              vala
              nodejs
              gcc
              gtk3
              gtk4
              libhandy
              libhandy.dev
              libhandy.devdoc
              libadwaita
              libadwaita.dev
              libadwaita.devdoc
              vadi-pkg
              ntk-pkg
              uncrustify
              gdb
              expidus-sdk-pkg
            ];

            shellHook = ''
              export PATH="$PWD/node_modules/.bin/:$PATH"
              alias run="npm run"
            '';
          };
        });

      submodules = true;
    };
}
