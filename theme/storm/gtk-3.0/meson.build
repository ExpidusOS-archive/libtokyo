theme_gtk3_storm = custom_target('theme-gtk3-storm',
  output: 'gtk.css',
  input: join_paths(meson.project_source_root(), 'gtk3', 'styling', 'storm.scss'),
  build_always: true,
  command: [sass, '@INPUT@', '@OUTPUT@', sass_flags],
  install: true,
  install_dir: join_paths(datadir, 'themes', 'Tokyo-Night-Storm', 'gtk-3.0'))

install_subdir(join_paths(meson.project_source_root(), 'gtk3', 'deps', 'adw-gtk3', 'gtk', 'src', 'adw-gtk3', 'gtk-3.0', 'assets'),
  install_dir: join_paths(datadir, 'themes', 'Tokyo-Night-Storm', 'gtk-3.0'),
  strip_directory: false)
