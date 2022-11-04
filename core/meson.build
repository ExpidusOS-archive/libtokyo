conf_data_core = configuration_data()
conf_data_core.merge_from(conf_data)

if handy.found()
  conf_data_core.set('HAS_PROVIDER_GTK3', 'true')
else
  conf_data_core.set('HAS_PROVIDER_GTK3', 'false')
endif

if adwaita.found()
  conf_data_core.set('HAS_PROVIDER_GTK4', 'true')
else
  conf_data_core.set('HAS_PROVIDER_GTK4', 'false')
endif

if ntk.found()
  conf_data_core.set('HAS_PROVIDER_NTK', 'true')
else
  conf_data_core.set('HAS_PROVIDER_NTK', 'false')
endif

build_conf_core = configure_file(input: 'lib/build.vala.in', output: 'build.vala',
 configuration: conf_data_core)
configure_file(input: 'lib/tokyo.deps.in', output: 'tokyo.deps',
  configuration: conf_data_core,
  install: true,
  install_dir: join_paths(datadir, 'vala', 'vapi'))

libtokyo_core_rel_sources = ['lib/application.vala', 'lib/applicationwindow.vala',
  'lib/main.vala', 'lib/provider.vala', 'lib/stylemanager.vala', 'lib/window.vala']
libtokyo_core_sources = []

foreach src : libtokyo_core_rel_sources
  libtokyo_core_sources += [join_paths(meson.current_source_dir(), src)]
endforeach

if uncrustify.found()
  run_target('core-prettier',
    command: [uncrustify, '--no-backup', libtokyo_core_sources])
endif

libtokyo_core_sources += [build_conf_core]

libtokyo_core = shared_library('tokyo', build_conf_core, libtokyo_core_rel_sources,
  c_args: ['-DG_LOG_DOMAIN="Tokyo"', '-DGETTEXT_PACKAGE="libtokyo"'],
  vala_args: ['--define=GETTEXT_PACKAGE="libtokyo"'],
  vala_gir: 'Tokyo-@0@.gir'.format(shortver.split('-')[0]),
  dependencies: [vadi, gio, gmodule, libintl],
  version: shortver.split('-')[0],
  install: true,
  install_dir: [true, true, true, true])
libtokyo_core_dep = declare_dependency(link_with: libtokyo_core, dependencies: [vadi, gio, gmodule, libintl],
  compile_args: ['-I' + join_paths(meson.project_build_root(), 'core')])
pkg.generate(libtokyo_core,
  name: 'tokyo',
  requires: ['gio-2.0', 'vadi-0.0'],
  description: 'A common type library used for loading libtokyo',
  url: 'https://github.com/ExpidusOS/libtokyo',
  version: longver)

executable('tokyo-core-example', ['examples/main.vala'],
  dependencies: [libtokyo_core_dep])

subdir('docs', if_found: [valadoc])

if get_option('tests')
  subdir('tests')
endif
