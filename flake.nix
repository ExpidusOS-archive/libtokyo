{
  description = "A libadwaita wrapper for ExpidusOS with Tokyo Night's styling";

  inputs.vadi = {
    url = github:ExpidusOS/Vadi/feat/nix;
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.ntk = {
    url = path:./subprojects/ntk;
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

      packagesFor = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};

          vadi-pkg = vadi.packages.${system}.default;
          ntk-pkg = ntk.packages.${system}.default;
          expidus-sdk-pkg = expidus-sdk.packages.${system}.default;
        in with pkgs; rec {
          nativeBuildInputs = [ meson ninja pkg-config vala glib sass nodejs expidus-sdk-pkg ];
          buildInputs = [ vadi-pkg ];
          buildInputsGtk3 = [ gtk3 libhandy ];
          buildInputsGtk4 = [ gtk4 libadwaita ];
          buildInputsNtk = [ ntk-pkg ];
          buildInputsFull = buildInputs ++ buildInputsGtk3 ++ buildInputsGtk4 ++ buildInputsNtk;
        });
    in
    {
      packages = forAllSystems (system:
        let
          packages = packagesFor.${system};
          pkgs = nixpkgsFor.${system};

          mkDerivation = ({ name, buildInputs, mesonFlags ? [] }: pkgs.stdenv.mkDerivation rec {
            inherit name buildInputs src mesonFlags;

            outputs = [ "out" "dev" "devdoc" ];

            enableParallelBuilding = true;
            inherit (packages) nativeBuildInputs;

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
            buildInputs = packages.buildInputsFull;
          };

          gtk3 = mkDerivation {
            name = "libtokyo-gtk3";
            mesonFlags = ["-Dntk=disabled" "-Dgtk4=disabled" "-Dgtk3=enabled" "-Dnodejs=disabled"];
            buildInputs = packages.buildInputs ++ packages.buildInputsGtk4;
          };

          gtk4 = mkDerivation {
            name = "libtokyo-gtk4";
            mesonFlags = ["-Dntk=disabled" "-Dgtk4=enabled" "-Dgtk3=disabled" "-Dnodejs=disabled"];
            buildInputs = packages.buildInputs ++ packages.buildInputsGtk4;
          };

          ntk = mkDerivation {
            name = "libtokyo-ntk";
            mesonFlags = ["-Dntk=enabled" "-Dgtk4=disabled" "-Dgtk3=disabled" "-Dnodejs=disabled"];
            buildInputs = packages.buildInputs ++ packages.buildInputsNtk;
          };
        });

      devShells = forAllSystems (system:
        let
          packages = packagesFor.${system};
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            packages = packages.nativeBuildInputs ++ packages.buildInputsFull;

            shellHook = ''
              export PATH="$PWD/node_modules/.bin/:$PATH"
              alias run="npm run"
            '';
          };
        });

      submodules = true;
    };
}
