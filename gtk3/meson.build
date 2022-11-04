conf_data_gtk3 = configuration_data()
conf_data_gtk3.merge_from(conf_data)
conf_data_gtk3.set('GTK_VERSION', '3')

build_conf_gtk3 = configure_file(input: 'lib/build.vala.in', output: 'build.vala',
 configuration: conf_data_gtk3)
configure_file(input: 'lib/tokyo-gtk3.deps.in', output: 'tokyo-gtk3.deps',
  configuration: conf_data_core,
  install: true,
  install_dir: join_paths(datadir, 'vala', 'vapi'))

build_res_gtk3 = configure_file(input: 'data/tokyo-gtk.gresource.xml.in', output: 'tokyo-gtk3.gresource.xml',
  configuration: conf_data_gtk3)

tokyo_gtk3_res = gnome.compile_resources('tokyo-gtk3-resources', build_res_gtk3,
  c_name: 'tokyo_gtk',
  dependencies: [theme_gtk3_default, theme_gtk3_light, theme_gtk3_storm])

libtokyo_gtk3_rel_sources = ['lib/application.vala', 'lib/applicationwindow.vala',
  'lib/calendar.vala', 'lib/calendarevents.vala', 'lib/events.vala', 'lib/eventslist.vala',
  'lib/init.vala', 'lib/provider.vala', 'lib/stylemanager.vala', 'lib/window.vala']
libtokyo_gtk3_sources = []

foreach src : libtokyo_gtk3_rel_sources
  libtokyo_gtk3_sources += [join_paths(meson.current_source_dir(), src)]
endforeach

if uncrustify.found()
  run_target('gtk3-prettier',
    command: [uncrustify, '--no-backup', libtokyo_gtk3_sources])
endif

libtokyo_gtk3_sources += [build_conf_gtk3]
libtokyo_gtk3_deps = [handy, libical, libtokyo_core_dep]

libtokyo_gtk3 = shared_library('tokyo-gtk3', build_conf_gtk3, tokyo_gtk3_res, libtokyo_gtk3_rel_sources,
  c_args: ['-DG_LOG_DOMAIN="TokyoGtk"', '-DGETTEXT_PACKAGE="libtokyo"', '-DLIBICAL_GLIB_UNSTABLE_API=1'],
  vala_args: ['--define=GETTEXT_PACKAGE="libtokyo"'],
  vala_gir: 'TokyoGtk3-@0@.gir'.format(shortver.split('-')[0]),
  dependencies: libtokyo_gtk3_deps,
  version: shortver.split('-')[0],
  install: true,
  install_dir: [true, true, true, true])
libtokyo_gtk3_dep = declare_dependency(link_with: libtokyo_gtk3, dependencies: libtokyo_gtk3_deps)
pkg.generate(libtokyo_gtk3,
  name: 'tokyo-gtk3',
  requires: ['libhandy-1 >= 1.6.0'],
  description: 'A libhandy wrapper for ExpidusOS with Tokyo Night\'s styling',
  url: 'https://github.com/ExpidusOS/libtokyo',
  version: longver)

executable('tokyo-gtk3-example', ['examples/main.vala'],
  c_args: ['-DLIBICAL_GLIB_UNSTABLE_API=1'],
  dependencies: [libtokyo_gtk3_dep])

subdir('docs', if_found: [valadoc])

if get_option('tests')
  subdir('tests')
endif
