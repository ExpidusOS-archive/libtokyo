gtk3_theme_light_conf_data = configuration_data()
gtk3_theme_light_conf_data.set('VARIANT', '-Light')
gtk3_theme_light_conf_data.set('VARIANT_NAME', ' Light')

configure_file(input: '../index.theme.in',
  output: 'index.theme',
  configuration: gtk3_theme_light_conf_data,
  install: true,
  install_dir: join_paths(datadir, 'themes', 'Tokyo-Night-Light'))

subdir('gtk-3.0')
subdir('gtk-4.0', if_found: [adwaita])
