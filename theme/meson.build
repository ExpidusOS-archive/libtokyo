if adwaita.found()
  adwaita_shlib = join_paths(adwaita.get_variable('libdir'), adwaita.name() + '.so')
  if fs.exists(adwaita_shlib)
    adwaita_extract = custom_target('adwaita-extract',
      input: adwaita_shlib,
      output: 'adwaita-extracted.scss',
      capture: true,
      build_by_default: true,
      command: [gresource, 'extract', '@INPUT@', '/org/gnome/Adwaita/styles/base.css'])
  else
    adwaita_extract = custom_target('adwaita_extract',
      output: 'adwaita-extracted.scss',
      capture: true,
      build_by_default: true,
      command: [extract_adwaita, '/org/gnome/Adwaita/styles/base.css'])
  endif

  adwaita_styles = custom_target('nodejs',
    output: 'adwaita.scss',
    input: adwaita_extract,
    build_always: true,
    build_by_default: true,
    command: [node, join_paths(meson.project_source_root(), 'scripts', 'patch-adwaita-styles.js'), '@INPUT@', '@OUTPUT@'])
endif

subdir('default')
subdir('storm')
subdir('light')
