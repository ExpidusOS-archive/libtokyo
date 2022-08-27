{
  description = "A libadwaita wrapper for ExpidusOS with Tokyo Night's styling";
  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
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
            
            nativebuildInputs = with pkgs; [ meson ninja pkg-config vala glib sass ];
            buildInputs = with pkgs; [ libadwaita ];

            enableParallelBuilding = true;
          };
        });
    };
}
