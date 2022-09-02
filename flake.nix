{
  description = "A libadwaita wrapper for ExpidusOS with Tokyo Night's styling";
  outputs = { self, nixpkgs }:
    let
      supportedSystems = [
        "aarch64-linux"
        "aarch64-darwin"
        "i686-linux"
        "riscv64-linux"
        "x86_64-linux"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};

          mkDerivation = ({ name, buildInputs }: pkgs.stdenv.mkDerivation rec {
            inherit name buildInputs;

            src = self;
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
            buildInputs = with pkgs; [ gtk3 libhandy gtk4 libadwaita ];
          };

          gtk3 = mkDerivation {
            name = "libtokyo-gtk3";
            buildInputs = with pkgs; [ gtk3 libhandy ];
          };

          gtk4 = mkDerivation {
            name = "libtokyo-gtk4";
            buildInputs = with pkgs; [ gtk4 libadwaita ];
          };
        });

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
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
              libhandy.dev
              libhandy.devdoc
              libadwaita.dev
              libadwaita.devdoc
            ];

            shellHook = ''
              export PATH="$PWD/node_modules/.bin/:$PATH"
              alias run="npm run"
            '';
          };
        });
    };
}
