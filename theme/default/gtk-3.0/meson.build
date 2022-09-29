custom_target('theme-gtk3-default',
  output: 'gtk.css',
  input: '../../../gtk3/styling/default.scss',
  build_always: true,
  command: [sass, '@INPUT@', '@OUTPUT@', sass_flags],
  install: true,
  install_dir: join_paths(datadir, 'themes', 'Tokyo-Night', 'gtk-3.0'))
