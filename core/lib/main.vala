namespace Tokyo {
  private static bool _is_init = false;

  public static bool is_initialized() {
    return _is_init;
  }

  public static void init() {
    if (_is_init) {
      return;
    }

    _is_init = true;

    GLib.debug("Initializing Tokyo Core");

    bind_i18n();

    if (global_provider == null) {
      if (HAS_PROVIDER_GTK4) {
        GLib.debug("Loading GTK 4 library");
        global_provider = Provider.load("libtokyo-gtk4." + GLib.Module.SUFFIX, "tokyo_gtk_provider_get_type");
      }

      if (HAS_PROVIDER_GTK3 && global_provider == null) {
        GLib.debug("Loading GTK 3 library");
        global_provider = Provider.load("libtokyo-gtk3." + GLib.Module.SUFFIX, "tokyo_gtk_provider_get_type");
      }

      if (HAS_PROVIDER_NTK && global_provider == null) {
        GLib.debug("Loading NTK library");
        global_provider = Provider.load("libtokyo-ntk." + GLib.Module.SUFFIX, "tokyo_ntk_provider_get_type");
      }
    }

    if (global_provider == null) {
      _is_init = false;
      GLib.critical("Failed to load libtokyo provider, none found");
    }
  }

  internal void bind_i18n() {
    GLib.Intl.bind_textdomain_codeset(GETTEXT_PACKAGE, "UTF-8");
    GLib.Intl.bindtextdomain(GETTEXT_PACKAGE, LOCALDIR);
  }
}
