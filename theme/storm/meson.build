gtk3_theme_storm_conf_data = configuration_data()
gtk3_theme_storm_conf_data.set('VARIANT', '-Storm')
gtk3_theme_storm_conf_data.set('VARIANT_NAME', ' Storm')

configure_file(input: '../index.theme.in',
  output: 'index.theme',
  configuration: gtk3_theme_storm_conf_data,
  install: true,
  install_dir: join_paths(datadir, 'themes', 'Tokyo-Night-Storm'))

subdir('gtk-3.0')
subdir('gtk-4.0', if_found: [adwaita])
