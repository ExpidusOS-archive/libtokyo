custom_target('theme-gtk3-light',
  output: 'gtk.css',
  input: '../../../gtk3/styling/light.scss',
  build_always: true,
  command: [sass, '@INPUT@', '@OUTPUT@', sass_flags],
  install: true,
  install_dir: join_paths(datadir, 'themes', 'Tokyo-Night-Light', 'gtk-3.0'))
