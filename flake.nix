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
        in
        {
          default = pkgs.stdenv.mkDerivation rec {
            name = "libtokyo";
            src = self;
            outputs = [ "out" "dev" ];
            
            nativeBuildInputs = with pkgs; [ meson ninja pkg-config vala glib sass ];
            buildInputs = with pkgs; [ libadwaita ];

            enableParallelBuilding = true;

            meta = with pkgs.lib; {
              homepage = "https://github.com/ExpidusOS/libtokyo";
              license = with licenses; [ gpl3Only ];
              maintainers = [ "Tristan Ross" ];
            };
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
              libadwaita.dev
              libadwaita.devdoc
            ];

            shellHooks = ''
              export PATH="$PWD/node_modules/.bin/:$PATH"
              alias run="npm run"
            '';
          };
        });
    };
}
