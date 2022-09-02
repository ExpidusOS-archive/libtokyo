project('libtokyo', 'vala', 'c', license: 'GPL-3.0-only', version: '0.1.0-prealpha')

gnome = import('gnome')
pkg = import('pkgconfig')

prefix = get_option('prefix')
bindir = prefix / get_option('bindir')
datadir = prefix / get_option('datadir')
libdir = prefix / get_option('libdir')
libexecdir = prefix / get_option('libexecdir')
localstatedir = get_option('localstatedir')

longver = '@0@'.format(meson.project_version())
shortver = longver
git = find_program('git', native: true, required: false)
if git.found()
	git_commit = run_command([git, 'rev-parse', '--short', 'HEAD'])
	git_branch = run_command([git, 'rev-parse', '--abbrev-ref', 'HEAD'])
	if git_commit.returncode() == 0 and git_branch.returncode() == 0
    shortver = '@0@-@1@'.format(meson.project_version(), git_commit.stdout().strip())
		longver = '@0@ (branch \'@1@\')'.format(shortver, git_branch.stdout().strip())
	endif
endif

node = find_program('node', required: false)
sass = find_program('sass', './node_modules/.bin/sass', required: true)
unbuild = find_program('unbuild', './node_modules/.bin/unbuild', required: node.found())

if node.found() and git.found()
  run_command([node, './scripts/update-package.js', shortver])
endif

adwaita = dependency('libadwaita-1', required: false, version: '>= 1.1.0')
handy = dependency('libhandy-1', required: false, version: '>= 1.6.0')

conf_data = configuration_data()
conf_data.set('PREFIX', prefix)
conf_data.set('BINDIR', bindir)
conf_data.set('DATADIR', datadir)
conf_data.set('LIBDIR', libdir)
conf_data.set('LIBEXECDIR', libexecdir)
conf_data.set('VERSION', longver)
conf_data.set('BUILDDIR', meson.current_build_dir())
conf_data.set('SOURCEDIR', meson.current_source_dir())

if unbuild.found()
  custom_target('nodejs',
    output: 'output',
    input: 'src/styling/index.ts',
    build_always: true,
    env: {
      'OUTDIR': '@0@/output'.format(meson.current_build_dir())
    },
    command: [unbuild, meson.current_source_dir()])
endif

build_conf_h = configure_file(input: 'src/build.h.in', output: 'build.h',
	configuration: conf_data)
build_conf = configure_file(input: 'src/build.vala.in', output: 'build.vala',
	configuration: conf_data)

if adwaita.found()
  conf_data_gtk4 = configuration_data()
  conf_data_gtk4.merge_from(conf_data)
  conf_data_gtk4.set('GTK_VERSION', '4')

  build_res_gtk4 = configure_file(input: 'src/tokyo-gtk.gresource.xml.in', output: 'tokyo-gtk4.gresource.xml',
    configuration: conf_data_gtk4)

  gtk4_default = custom_target('styling-gtk4-default',
    output: 'gtk4-default.css',
    input: 'src/styling/gtk4/default.scss',
    build_always: true,
    command: [sass, '@INPUT@', '@OUTPUT@'])
  gtk4_light = custom_target('styling-gtk4-light',
    output: 'gtk4-light.css',
    input: 'src/styling/gtk4/light.scss',
    build_always: true,
    command: [sass, '@INPUT@', '@OUTPUT@'])
  gtk4_storm = custom_target('styling-gtk4-storm',
    output: 'gtk4-storm.css',
    input: 'src/styling/gtk4/storm.scss',
    build_always: true,
    command: [sass, '@INPUT@', '@OUTPUT@'])

  tokyo_gtk4_res = gnome.compile_resources('tokyo-gtk4-resources', build_res_gtk4,
    c_name: 'tokyo_gtk',
    dependencies: [gtk4_storm, gtk4_light, gtk4_default])

  libtokyo_gtk4 = shared_library('tokyo-gtk4', [build_conf_h, build_conf, tokyo_gtk4_res, 'src/gtk4/application.vala', 'src/gtk4/applicationwindow.vala', 'src/gtk4/init.vala', 'src/gtk4/stylemanager.vala', 'src/gtk4/window.vala'],
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

  executable('tokyo-gtk4-example', ['src/examples/gtk4/main.vala'],
    dependencies: [libtokyo_gtk4_dep])
endif

if handy.found()
  gtk3_default = custom_target('styling-gtk3-default',
    output: 'gtk3-default.css',
    input: 'src/styling/gtk3/default.scss',
    build_always: true,
    command: [sass, '@INPUT@', '@OUTPUT@'])
  gtk3_light = custom_target('styling-gtk3-light',
    output: 'gtk3-light.css',
    input: 'src/styling/gtk3/light.scss',
    build_always: true,
    command: [sass, '@INPUT@', '@OUTPUT@'])
  gtk3_storm = custom_target('styling-gtk3-storm',
    output: 'gtk3-storm.css',
    input: 'src/styling/gtk3/storm.scss',
    build_always: true,
    command: [sass, '@INPUT@', '@OUTPUT@'])
 
  conf_data_gtk3 = configuration_data()
  conf_data_gtk3.merge_from(conf_data)
  conf_data_gtk3.set('GTK_VERSION', '3')

  build_res_gtk3 = configure_file(input: 'src/tokyo-gtk.gresource.xml.in', output: 'tokyo-gtk3.gresource.xml',
    configuration: conf_data_gtk3)

  tokyo_gtk3_res = gnome.compile_resources('tokyo-gtk3-resources', build_res_gtk3,
    c_name: 'tokyo_gtk',
    dependencies: [gtk3_storm, gtk3_light, gtk3_default])

  libtokyo_gtk3 = shared_library('tokyo-gtk3', [build_conf_h, build_conf, tokyo_gtk3_res, 'src/gtk3/application.vala', 'src/gtk3/applicationwindow.vala', 'src/gtk3/init.vala', 'src/gtk3/stylemanager.vala', 'src/gtk3/window.vala'],
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

  executable('tokyo-gtk3-example', ['src/examples/gtk3/main.vala'],
    dependencies: [libtokyo_gtk3_dep])
endif
