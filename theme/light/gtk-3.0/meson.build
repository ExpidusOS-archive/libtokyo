theme_gtk3_light = custom_target('theme-gtk3-light',
  output: 'gtk.css',
  input: join_paths(meson.project_source_root(), 'gtk3', 'styling', 'light.scss'),
  build_always: true,
  command: [sass, '@INPUT@', '@OUTPUT@', sass_flags],
  install: true,
  install_dir: join_paths(datadir, 'themes', 'Tokyo-Night-Light', 'gtk-3.0'))

install_subdir(join_paths(meson.project_source_root(), 'gtk3', 'deps', 'adw-gtk3', 'gtk', 'src', 'adw-gtk3', 'gtk-3.0', 'assets'),
  install_dir: join_paths(datadir, 'themes', 'Tokyo-Night-Light', 'gtk-3.0'),
  strip_directory: false)
