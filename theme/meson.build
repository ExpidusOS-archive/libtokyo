if adwaita.found()
  adwaita_shlib = join_paths(adwaita.get_variable('libdir'), adwaita.name())
  if target_machine.system() == 'darwin'
    adwaita_shlib += '.dylib'
  elif target_machine.system() == 'windows'
    adwaita_shlib += '.dll'
  else
    adwaita_shlib += '.so'
  endif

  adwaita_extract = custom_target('adwaita-extract',
    input: adwaita_shlib,
    output: 'adwaita-extracted.css',
    capture: true,
    build_by_default: true,
    command: [gresource, 'extract', '@INPUT@', '/org/gnome/Adwaita/styles/base.css'])

  adwaita_styles = custom_target('adwaita-styles',
    input: adwaita_extract,
    output: 'adwaita.css',
    capture: true,
    build_by_default: true,
    command: [grep, '--invert-match', 'define-color', '@INPUT@'])
endif

subdir('default')
subdir('storm')
subdir('light')
