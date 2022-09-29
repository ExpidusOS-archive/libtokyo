gtk3_theme_default_conf_data = configuration_data()
gtk3_theme_default_conf_data.set('VARIANT', '')
gtk3_theme_default_conf_data.set('VARIANT_NAME', '')

configure_file(input: '../index.theme.in',
  output: 'index.theme',
  configuration: gtk3_theme_default_conf_data,
  install: true,
  install_dir: join_paths(datadir, 'themes', 'Tokyo-Night'))
