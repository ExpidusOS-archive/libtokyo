if adwaita.found()
  adwaita_shlib = join_paths(adwaita.get_variable('libdir'), adwaita.name() + '.so')
  adwaita_asset_names = ['bullet-symbolic.symbolic.png', 'bullet@2-symbolic.symbolic.png',
    'check-symbolic.symbolic.png', 'check@2-symbolic.symbolic.png',
    'dash-symbolic.symbolic.png', 'dash@2-symbolic.symbolic.png',
    'bullet-symbolic.svg', 'check-symbolic.svg',
    'dash-symbolic.svg', 'devel-symbolic.svg']
  adwaita_assets = []

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

  foreach name : adwaita_asset_names
    asset_name = '/org/gnome/Adwaita/styles/assets/@0@'.format(name)
    if fs.exists(adwaita_shlib)
      adwaita_assets += [custom_target('adwaita-asset-@0@'.format(name),
        input: adwaita_shlib,
        output: name,
        capture: true,
        build_by_default: true,
        command: [gresource, 'extract', '@INPUT@', asset_name])]
    else
      adwaita_assets += [custom_target('adwaita-asset-@0@'.format(name),
        output: name,
        capture: true,
        build_by_default: true,
        command: [extract_adwaita, asset_name])]
    endif
  endforeach

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
