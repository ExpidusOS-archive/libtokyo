libtokyo_gtk4_docs_devhelp = custom_target('gtk4-docs-devhelp',
  input: libtokyo_gtk4_sources,
  output: 'devhelp',
  command: [valadoc, '-o', join_paths(meson.current_build_dir(), 'devhelp'), '--doclet', 'devhelp', '@INPUT@', '--force', '--pkg', 'libadwaita-1', '--package-name=libtokyo-gtk4', '--package-version=@0@'.format(shortver)],
  build_by_default: true,
  install: true,
  install_dir: join_paths(datadir, 'devhelp', 'books'))
