project('libtokyo', 'vala', 'c', license: 'GPL-3.0-only', version: '0.1.0-prealpha')

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

conf_data = configuration_data()
conf_data.set('PREFIX', prefix)
conf_data.set('BINDIR', bindir)
conf_data.set('DATADIR', datadir)
conf_data.set('LIBDIR', libdir)
conf_data.set('LIBEXECDIR', libexecdir)
conf_data.set('VERSION', '"@0@"'.format(longver))

custom_target('styling-gtk4-default',
  output: 'gtk4-default.css',
  input: 'src/styling/gtk4/default.scss',
  build_always: true,
  command: [sass, '@INPUT@', '@OUTPUT@'])
custom_target('styling-gtk4-light',
  output: 'gtk4-light.css',
  input: 'src/styling/gtk4/light.scss',
  build_always: true,
  command: [sass, '@INPUT@', '@OUTPUT@'])
custom_target('styling-gtk4-storm',
  output: 'gtk4-dark.css',
  input: 'src/styling/gtk4/storm.scss',
  build_always: true,
  command: [sass, '@INPUT@', '@OUTPUT@'])

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
