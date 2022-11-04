conf_data_gtk4 = configuration_data()
conf_data_gtk4.merge_from(conf_data)
conf_data_gtk4.set('GTK_VERSION', '4')

build_conf_gtk4 = configure_file(input: 'lib/build.vala.in', output: 'build.vala',
 configuration: conf_data_gtk4)
configure_file(input: 'lib/tokyo-gtk4.deps.in', output: 'tokyo-gtk4.deps',
  configuration: conf_data_core,
  install: true,
  install_dir: join_paths(datadir, 'vala', 'vapi'))

build_res_gtk4 = configure_file(input: 'data/tokyo-gtk.gresource.xml.in', output: 'tokyo-gtk4.gresource.xml',
  configuration: conf_data_gtk4)

gtk4_default = custom_target('styling-gtk4-default',
  output: 'gtk-default.css',
  input: 'styling/default.scss',
  build_always: true,
  build_by_default: true,
  command: [sass, '@INPUT@', '@OUTPUT@', sass_flags])
gtk4_light = custom_target('styling-gtk4-light',
  output: 'gtk-light.css',
  input: 'styling/light.scss',
  build_always: true,
  build_by_default: true,
  command: [sass, '@INPUT@', '@OUTPUT@', sass_flags])
gtk4_storm = custom_target('styling-gtk4-storm',
  output: 'gtk-storm.css',
  input: 'styling/storm.scss',
  build_always: true,
  build_by_default: true,
  command: [sass, '@INPUT@', '@OUTPUT@', sass_flags])

libtokyo_gtk4_rel_sources = ['lib/application.vala', 'lib/applicationwindow.vala', 'lib/calendarevents.vala', 'lib/init.vala', 'lib/provider.vala', 'lib/stylemanager.vala', 'lib/window.vala']
libtokyo_gtk4_sources = []

foreach src : libtokyo_gtk4_rel_sources
  libtokyo_gtk4_sources += [join_paths(meson.current_source_dir(), src)]
endforeach

if uncrustify.found()
  run_target('gtk4-prettier',
    command: [uncrustify, '--no-backup', libtokyo_gtk4_sources])
endif

libtokyo_gtk4_sources += [build_conf_gtk4]

tokyo_gtk4_res = gnome.compile_resources('tokyo-gtk4-resources', build_res_gtk4,
  c_name: 'tokyo_gtk',
  dependencies: [gtk4_storm, gtk4_light, gtk4_default])

libtokyo_gtk4 = shared_library('tokyo-gtk4', build_conf_gtk4, tokyo_gtk4_res, libtokyo_gtk4_rel_sources,
  c_args: ['-DG_LOG_DOMAIN="TokyoGtk"', '-DGETTEXT_PACKAGE="libtokyo"'],
  vala_args: ['--define=GETTEXT_PACKAGE="libtokyo"'],
  vala_gir: 'TokyoGtk4-@0@.gir'.format(shortver.split('-')[0]),
  dependencies: [adwaita, libtokyo_core_dep],
  version: shortver.split('-')[0],
  install: true,
  install_dir: [true, true, true, true])
libtokyo_gtk4_dep = declare_dependency(link_with: libtokyo_gtk4, dependencies: [adwaita, libtokyo_core_dep])
pkg.generate(libtokyo_gtk4,
  name: 'tokyo-gtk4',
  requires: ['libadwaita-1 >= 1.1.0'],
  description: 'A libadwaita wrapper for ExpidusOS with Tokyo Night\'s styling',
  url: 'https://github.com/ExpidusOS/libtokyo',
  version: longver)

executable('tokyo-gtk4-example', ['examples/main.vala'],
  dependencies: [libtokyo_gtk4_dep])

subdir('docs', if_found: [valadoc])

if get_option('tests')
  subdir('tests')
endif
