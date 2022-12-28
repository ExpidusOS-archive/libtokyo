custom_target('prism-default',
  output: 'theme.json',
  build_always: true,
  build_by_default: true,
  depends: [node_target],
  install: true,
  install_dir: join_paths(prism_dir, 'themes', 'Tokyo Night'),
  command: [node, prism_make, join_paths(meson.project_build_root(), 'output', 'styling.cjs'), 'default', '@OUTPUT@'])
