theme_gtk3_default = custom_target('theme-gtk3-default',
  output: 'gtk.css',
  input: '../../../gtk3/styling/default.scss',
  build_always: true,
  command: [sass, '@INPUT@', '@OUTPUT@', sass_flags],
  install: true,
  install_dir: join_paths(datadir, 'themes', 'Tokyo-Night', 'gtk-3.0'))

install_subdir('../../../gtk3/deps/adw-gtk3/gtk/src/adw-gtk3/gtk-3.0/assets', install_dir: join_paths(datadir, 'themes', 'Tokyo-Night', 'gtk-3.0'), strip_directory: false)
