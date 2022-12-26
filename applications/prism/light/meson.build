custom_target('prism-light',
  output: 'theme.json',
  build_always: true,
  build_by_default: true,
  install: true,
  install_dir: join_paths(prism_dir, 'themes', 'Tokyo Night Light'),
  command: [node, prism_make, join_paths(meson.project_build_root(), 'output', 'styling.cjs'), 'light', '@OUTPUT@'])
