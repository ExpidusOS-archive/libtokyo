conf_data_gtk3 = configuration_data()
conf_data_gtk3.merge_from(conf_data)
conf_data_gtk3.set('GTK_VERSION', '3')

build_conf_gtk3 = configure_file(input: 'lib/build.vala.in', output: 'build.vala',
 configuration: conf_data_gtk3)

build_res_gtk3 = configure_file(input: 'data/tokyo-gtk.gresource.xml.in', output: 'tokyo-gtk3.gresource.xml',
  configuration: conf_data_gtk3)

tokyo_gtk3_res = gnome.compile_resources('tokyo-gtk3-resources', build_res_gtk3,
  c_name: 'tokyo_gtk',
  dependencies: [theme_gtk3_default, theme_gtk3_light, theme_gtk3_storm])

subdir('po')

libtokyo_gtk3 = shared_library('tokyo-gtk3', [build_conf_gtk3, tokyo_gtk3_res, 'lib/application.vala', 'lib/applicationwindow.vala', 'lib/init.vala', 'lib/stylemanager.vala', 'lib/window.vala'],
  c_args: ['-DG_LOG_DOMAIN="TokyoGtk"', '-DGETTEXT_PACKAGE="libtokyo-gtk3"'],
  vala_args: ['--define=GETTEXT_PACKAGE="libtokyo-gtk3"'],
  vala_gir: 'TokyoGtk3-@0@.gir'.format(shortver.split('-')[0]),
  dependencies: [handy],
  version: shortver.split('-')[0],
  install: true,
  install_dir: [true, true, true, true])
libtokyo_gtk3_dep = declare_dependency(link_with: libtokyo_gtk3, dependencies: [handy])
pkg.generate(libtokyo_gtk3,
  name: 'tokyo-gtk3',
  requires: ['libhandy-1 >= 1.6.0'],
  description: 'A libhandy wrapper for ExpidusOS with Tokyo Night\'s styling',
  url: 'https://github.com/ExpidusOS/libtokyo',
  version: longver)

executable('tokyo-gtk3-example', ['examples/main.vala'],
  dependencies: [libtokyo_gtk3_dep])
