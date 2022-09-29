if adwaita.found()
  conf_data_gtk4 = configuration_data()
  conf_data_gtk4.merge_from(conf_data)
  conf_data_gtk4.set('GTK_VERSION', '4')

  build_conf_gtk4 = configure_file(input: 'lib/build.vala.in', output: 'build.vala',
	  configuration: conf_data_gtk4)

  build_res_gtk4 = configure_file(input: 'data/tokyo-gtk.gresource.xml.in', output: 'tokyo-gtk4.gresource.xml',
    configuration: conf_data_gtk4)

  gtk4_default = custom_target('styling-gtk4-default',
    output: 'gtk-default.css',
    input: 'styling/default.scss',
    build_always: true,
    command: [sass, '@INPUT@', '@OUTPUT@', '-I' + join_paths(meson.project_source_root(), 'styling')], '--default-encoding=UTF-8')
  gtk4_light = custom_target('styling-gtk4-light',
    output: 'gtk-light.css',
    input: 'styling/light.scss',
    build_always: true,
    command: [sass, '@INPUT@', '@OUTPUT@', '-I' + join_paths(meson.project_source_root(), 'styling')], '--default-encoding=UTF-8')
  gtk4_storm = custom_target('styling-gtk4-storm',
    output: 'gtk-storm.css',
    input: 'styling/storm.scss',
    build_always: true,
    command: [sass, '@INPUT@', '@OUTPUT@', '-I' + join_paths(meson.project_source_root(), 'styling')], '--default-encoding=UTF-8')

  tokyo_gtk4_res = gnome.compile_resources('tokyo-gtk4-resources', build_res_gtk4,
    c_name: 'tokyo_gtk',
    dependencies: [gtk4_storm, gtk4_light, gtk4_default])

  libtokyo_gtk4 = shared_library('tokyo-gtk4', [build_conf_gtk4, tokyo_gtk4_res, 'lib/application.vala', 'lib/applicationwindow.vala', 'lib/init.vala', 'lib/stylemanager.vala', 'lib/window.vala'],
    c_args: ['-DG_LOG_DOMAIN="TokyoGtk"'],
    vala_gir: 'TokyoGtk4-@0@.gir'.format(shortver.split('-')[0]),
    dependencies: [adwaita],
    version: shortver.split('-')[0],
    install: true,
    install_dir: [true, true, true, true])
  libtokyo_gtk4_dep = declare_dependency(link_with: libtokyo_gtk4, dependencies: [adwaita])
  pkg.generate(libtokyo_gtk4,
    name: 'tokyo-gtk4',
    requires: ['libadwaita-1 >= 1.1.0'],
    description: 'A libadwaita wrapper for ExpidusOS with Tokyo Night\'s styling',
    url: 'https://github.com/ExpidusOS/libtokyo',
    version: longver)

  executable('tokyo-gtk4-example', ['examples/main.vala'],
    dependencies: [libtokyo_gtk4_dep])
endif
