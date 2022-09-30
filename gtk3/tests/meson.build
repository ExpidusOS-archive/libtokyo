foreach name : ['application', 'window']
  test('gtk3/@0@'.format(name), executable('test-@0@'.format(name), name + '.vala',
      c_args: ['-I' + join_paths(meson.project_build_root(), 'gtk3')],
      dependencies: [libtokyo_gtk3_dep]),
    env: [
      'G_TEST_SRCDIR=@0@'.format(meson.current_source_dir()),
      'G_TEST_BUILDDIR=@0@'.format(meson.current_build_dir())
    ], protocol: 'tap')
endforeach
