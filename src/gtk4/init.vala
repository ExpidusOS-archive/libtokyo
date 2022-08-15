namespace TokyoGtk {
  public extern GLib.Resource get_resource();

  private static bool _is_init = false;

  public static bool is_initialized() {
    return _is_init;
  }

  public static void init() {
    if (_is_init) return;

    GLib.debug("Initializing Tokyo GTK");
    GLib.resources_register(get_resource());

    _is_init = true;
  }
}
