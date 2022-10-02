namespace TokyoGtk {
  public extern GLib.Resource get_resource();

  private static bool _is_init = false;

  public static bool is_initialized() {
    return _is_init;
  }

  public static void init() {
    if (_is_init) {
      return;
    }

    _is_init = true;

    GLib.debug("Initializing Tokyo GTK");
    GLib.resources_register(get_resource());

    unowned string[] args = null;
    Gtk.init(ref args);
    Hdy.init();

    GLib.Intl.bind_textdomain_codeset(GETTEXT_PACKAGE, "UTF-8");
    GLib.Intl.bindtextdomain(GETTEXT_PACKAGE, LOCALDIR);

    if (Tokyo.Provider.get_global() == null) {
      var provider = new TokyoGtk.Provider();
      Tokyo.Provider.set_global(provider);
      provider.get_style_manager_provider().ensure();
    }
  }
}
