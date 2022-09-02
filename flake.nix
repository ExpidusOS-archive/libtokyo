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

          nativeBuildInputs = with pkgs; [ meson ninja pkg-config vala glib sass ];
          meta = with pkgs.lib; {
            homepage = "https://github.com/ExpidusOS/libtokyo";
            license = with licenses; [ gpl3Only ];
            maintainers = [ "Tristan Ross" ];
          };
        in rec {
          default = pkgs.stdenv.mkDerivation rec {
            name = "libtokyo";
            src = self;
            outputs = [ "out" "dev" ];
            enableParallelBuilding = true;
            buildInputs = with pkgs; [ gtk3 gtk4 libadwaita libhandy ];
            
            inherit nativeBuildInputs meta;
          };

          gtk3 = pkgs.stdenv.mkDerivation rec {
            name = "libtokyo-gtk3";
            src = self;
            outputs = [ "out" "dev" ];
            enableParallelBuilding = true;
            buildInputs = with pkgs; [ gtk3 libhandy ];
            
            inherit nativeBuildInputs meta;
          });

          gtk4 = mks.stdenv.mkDerivation rec {
            name = "libtokyo-gtk4";
            src = self;
            outputs = [ "out" "dev" ];
            enableParallelBuilding = true;
            buildInputs = with pkgs; [ gtk4 libadwaita ];
            
            inherit nativeBuildInputs meta;
          });
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
