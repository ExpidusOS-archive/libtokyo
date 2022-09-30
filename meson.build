project('libtokyo', 'vala', 'c', license: 'GPL-3.0-only', version: '0.1.0-prealpha')

gnome = import('gnome')
i18n = import('i18n')
pkg = import('pkgconfig')
fs = import('fs')

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

adwaita = dependency('libadwaita-1', required: get_option('gtk4'), version: '>= 1.1.0')
use_nodejs = get_option('nodejs')

if adwaita.found()
  use_nodejs = true
endif

node = find_program('node', required: use_nodejs, native: true)
sass = find_program('sass', dirs: [join_paths(meson.project_source_root(), 'node_modules', '.bin')], required: true, native: true)
unbuild = find_program('unbuild', './node_modules/.bin/unbuild', required: get_option('nodejs'), native: true)

sass_flags = ['-I' + meson.project_source_root(), '-I' + meson.project_build_root()]
if sass.full_path() != join_paths(meson.project_source_root(), 'node_modules', '.bin', 'sass')
  sass_flags += ['--default-encoding=UTF-8']
endif

if node.found() and git.found()
  run_command([node, './scripts/update-package.js', shortver])
endif

gresource = find_program('gresource', required: adwaita.found())

handy = dependency('libhandy-1', required: get_option('gtk3'), version: '>= 1.6.0')
ntk = dependency('ntk', required: get_option('ntk').enabled())
has_ntk = ntk.found()
if not ntk.found() and not get_option('ntk').disabled()
  ntk_subproject = subproject('ntk')
  ntk = ntk_subproject.get_variable('libntk')
  has_ntk = true
endif

conf_data = configuration_data()
conf_data.set('PREFIX', prefix)
conf_data.set('BINDIR', bindir)
conf_data.set('DATADIR', datadir)
conf_data.set('LIBDIR', libdir)
conf_data.set('LIBEXECDIR', libexecdir)
conf_data.set('VERSION', longver)
conf_data.set('BUILDDIR', meson.current_build_dir())
conf_data.set('SOURCEDIR', meson.current_source_dir())

if unbuild.found() and node.found()
  custom_target('nodejs',
    output: 'output',
    input: 'styling/index.ts',
    build_always: true,
    env: {
      'OUTDIR': '@0@/output'.format(meson.current_build_dir())
    },
    command: [unbuild, meson.current_source_dir()])
endif

subdir('po')
subdir('build-tools')
subdir('theme')
subdir('gtk4', if_found: [adwaita])
subdir('gtk3', if_found: [handy])
