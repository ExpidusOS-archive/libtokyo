namespace Tokyo {
  internal static Provider? global_provider;

  internal delegate GLib.Type ProviderTypeFunc();

  /**
   * libtokyo Provider is used to provide types using Vadi
   */
  public abstract class Provider : GLib.Object {
    private Vdi.Container _container;

    public static Provider? load_from_path(string path, string type_fn_name) {
      GLib.debug("Loading provider type \"%s\" from %s", type_fn_name, path);

      var module = GLib.Module.open(path, GLib.ModuleFlags.LAZY);
      if (module == null) {
        GLib.warning("Failed to load provider \"%s\" from %s", type_fn_name, path);
        return null;
      }

      void* type_fn_ptr = null;
      return_val_if_fail(module.symbol(type_fn_name, out type_fn_ptr), null);

      ProviderTypeFunc type_fn = (ProviderTypeFunc)type_fn_ptr;
      return_val_if_fail(type_fn != null, null);

      return GLib.Object.@new(type_fn()) as Provider;
    }

    public static Provider? load(string modname, string type_fn_name) {
      var path = GLib.Environment.get_variable("TOKYO_LIBDIR");
      if (path == null) path = LIBDIR;

      return load_from_path(GLib.Module.build_path(path, modname), type_fn_name);
    }

    public static Provider? get_global() {
      return global_provider;
    }

    construct {
      this._container = new Vdi.Container();
      this.init(this._container);
    }

    /**
     * Initialization function is used to bind types to the Vadi Container
     */
    public abstract void init(Vdi.Container container);

    public ApplicationProvider get_application_provider() {
      return this._container.get(typeof (ApplicationProvider)) as ApplicationProvider;
    }

    public WindowProvider get_window_provider() {
      return this._container.get(typeof (WindowProvider)) as WindowProvider;
    }

    public StyleManagerProvider get_style_manager_provider() {
      return this._container.get(typeof (StyleManagerProvider)) as StyleManagerProvider;
    }
  }
}
