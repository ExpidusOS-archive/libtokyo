{
  description = "A libadwaita wrapper for ExpidusOS with Tokyo Night's styling";
  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.libtokyo = nixpkgs.legacyPackages.x86_64-linux.libtokyo;
    defaultPackage.x86_64-linux = self.packages.x86_64-linux.libtokyo;
  };
}
