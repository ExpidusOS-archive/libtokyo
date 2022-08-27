{
  description = "A libadwaita wrapper for ExpidusOS with Tokyo Night's styling";
  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default = 
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        name = "libtokyo";
        src = self;
        outputs = [ "dev" ];
        nativebuildInputs = [ nodejs meson ninja vala pkg-config ];
        buildInputs = [ libadwaita.dev ];
        mesonWrapMode = "default";
      };
  };
}
