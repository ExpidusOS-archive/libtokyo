theme_default_conf_data = configuration_data()
theme_default_conf_data.set('VARIANT', '')
theme_default_conf_data.set('VARIANT_NAME', '')

configure_file(input: '../index.theme.in',
  output: 'index.theme',
  configuration: theme_default_conf_data,
  install: true,
  install_dir: join_paths(datadir, 'themes', 'Tokyo-Night'))

subdir('gtk-3.0')
subdir('gtk-4.0', if_found: [adwaita])
