{
  description = "A libadwaita wrapper for ExpidusOS with Tokyo Night's styling";

  inputs.ntk = {
    url = path:./subprojects/ntk;
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ntk }:
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
          ntk-pkg = ntk.packages.${system}.default;

          mkDerivation = ({ name, buildInputs, mesonFlags ? [] }: pkgs.stdenv.mkDerivation rec {
            inherit name buildInputs src mesonFlags;

            outputs = [ "out" "dev" ];

            enableParallelBuilding = true;
            nativeBuildInputs = with pkgs; [ meson ninja pkg-config vala glib sass ];

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
            buildInputs = with pkgs; [ gtk3 libhandy gtk4 libadwaita ntk-pkg ];
          };

          gtk3 = mkDerivation {
            name = "libtokyo-gtk3";
            mesonFlags = ["-Dntk=disabled" "-Dgtk4=disabled" "-Dgtk3=enabled" "-Dnodejs=disabled"];
            buildInputs = with pkgs; [ gtk3 libhandy ];
          };

          gtk4 = mkDerivation {
            name = "libtokyo-gtk4";
            mesonFlags = ["-Dntk=disabled" "-Dgtk4=enabled" "-Dgtk3=disabled" "-Dnodejs=disabled"];
            buildInputs = with pkgs; [ gtk4 libadwaita ];
          };

          ntk = mkDerivation {
            name = "libtokyo-ntk";
            mesonFlags = ["-Dntk=enabled" "-Dgtk4=disabled" "-Dgtk3=disabled" "-Dnodejs=disabled"];
            buildInputs = with pkgs; [ ntk-pkg ];
          };
        });

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          ntk-pkg = ntk.packages.${system}.default;
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
              ntk-pkg
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
