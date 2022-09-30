theme_gtk4_default_conf = configuration_data()
theme_gtk4_default_conf.merge_from(conf_data)
theme_gtk4_default_conf.set('VARIANT', 'default')

theme_gtk4_default_scss = configure_file(input: join_paths(meson.project_source_root(), 'gtk4', 'styling', 'theme.scss.in'),
  output: 'gtk.scss',
  configuration: theme_gtk4_default_conf)

theme_gtk4_default = custom_target('theme-gtk4-default',
  depends: [adwaita_styles],
  output: 'gtk.css',
  input: theme_gtk4_default_scss,
  build_always: true,
  command: [sass, '@INPUT@', '@OUTPUT@', sass_flags],
  install: true,
  install_dir: join_paths(datadir, 'themes', 'Tokyo-Night', 'gtk-4.0'))
