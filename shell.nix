{ pkgs ? import <nixpkgs> {} } :

pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs
    meson
    ninja
    gcc
    vala
    libadwaita.devdoc
  ];
  shellHooks = ''
    export PATH="$PWD/node_modules/.bin/:$PATH"
    alias run="npm run"
  '';
}
