libtokyo_gtk4_docs_devhelp = custom_target('gtk4-docs-devhelp',
  input: libtokyo_gtk4_sources,
  output: 'devhelp',
  command: [valadoc, '-o', join_paths(meson.current_build_dir(), 'devhelp'),
    '--doclet', 'devhelp', '@INPUT@', '--force',
    '--vapidir', join_paths(meson.project_build_root(), 'core'),
    '--pkg', 'libadwaita-1', '--pkg', 'vadi-0.0', '--pkg', 'tokyo',
    '--package-name=libtokyo-gtk4', '--package-version=@0@'.format(shortver)],
  build_by_default: true)

install_subdir(join_paths(meson.current_build_dir(), 'devhelp', 'libtokyo-gtk4'), install_dir: join_paths(datadir, 'devhelp', 'books'))
