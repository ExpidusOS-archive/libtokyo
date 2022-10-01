libtokyo_core_docs_devhelp = custom_target('core-docs-devhelp',
  input: libtokyo_core_sources,
  output: 'devhelp',
  command: [valadoc, '-o', join_paths(meson.current_build_dir(), 'devhelp'), '--doclet', 'devhelp', '@INPUT@', '--force', '--pkg', 'vadi-0.0', '--pkg', 'gio-2.0', '--pkg', 'gmodule-2.0', '--package-name=libtokyo', '--package-version=@0@'.format(shortver)],
  build_by_default: true)

install_subdir(join_paths(meson.current_build_dir(), 'devhelp', 'libtokyo'), install_dir: join_paths(datadir, 'devhelp', 'books'))
