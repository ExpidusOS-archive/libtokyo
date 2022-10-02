namespace Tokyo {
  /**
   * Provider for Applications
   */
  public interface ApplicationProvider : GLib.Object {
    public abstract void startup(GLib.Application app);
    public abstract void shutdown(GLib.Application app);
  }

  /**
   * Application class
   */
  public abstract class Application : GLib.Application {
    private uint _menu_dbus_id;
    private Provider? _provider;
    private string? _provider_fn;
    private string? _provider_lib;
    private GLib.List<Window> _windows;

    public Provider provider {
      get {
        if (this._provider == null) this._provider = Provider.get_global();
        return this._provider;
      }
      set construct {
        this._provider = value;
      }
    }

    construct {
      bind_i18n();

      GLib.OptionEntry[] options = {
        { "libtokyo-provider-func", '\0', GLib.OptionFlags.NONE, GLib.OptionArg.STRING, ref this._provider_fn, N_("The GLib get_type function to use for the provider"), "FUNC" },
        { "libtokyo-provider-lib", '\0', GLib.OptionFlags.NONE, GLib.OptionArg.FILENAME, ref this._provider_lib, N_("The path to the library to use for loading libtokyo"), "LIB" },
        { null }
      };

      var self = this;
      var group = new GLib.OptionGroup("libtokyo", N_("libtokyo Options"), N_("Show all options for the libtokyo library"));
      group.add_entries(options);
      this.add_option_group(group);
    }

    public void add_window(Window win) {
      if (this.get_window_by_id(win.id) == null) {
        this._windows.append(win);
        this.window_added(win);

        var dbus_conn = this.get_dbus_connection();
        var dbus_path = this.get_dbus_object_path();

        try {
          if (dbus_conn != null && dbus_path != null) {
            win.dbus_register(dbus_conn, "%s/windows/%lu".printf(dbus_path, win.id));
          }
        } catch (GLib.Error e) {
          this._windows.remove(win);
          GLib.error("Failed to register window %lu to DBus: %s:%d: %s", win.id, e.domain.to_string(), e.code, e.message);
        }
      }
    }

    public void remove_window(Window win) {
      var fwin = this.get_window_by_id(win.id);
      if (fwin != null) {
        this._windows.remove(fwin);
        this.window_removed(fwin);

        var dbus_conn = this.get_dbus_connection();
        var dbus_path = this.get_dbus_object_path();

        if (dbus_conn != null && dbus_path != null) {
          win.dbus_unregister(dbus_conn, "%s/windows/%lu".printf(dbus_path, win.id));
        }
      }
    }

    public unowned Window? get_window_by_id(uint id) {
      unowned var item = this._windows.search(id, (win, wid) => {
        return (int)(win.id - ((uint)wid));
      });
      return item == null ? null : item.data;
    }

    public unowned GLib.List<Window> get_windows() {
      return this._windows;
    }

    public override bool dbus_register(GLib.DBusConnection connection, string object_path) throws GLib.Error {
      return_val_if_fail(base.dbus_register(connection, object_path), false);

      var menu = new GLib.Menu();

      var appMenu = new GLib.Menu();
      appMenu.append_item(new GLib.MenuItem(N_("About"), "app.about"));
      appMenu.append_item(new GLib.MenuItem(N_("Preferences"), "app.preferences"));
      menu.append_section(null, appMenu);

      var windowMenu = new GLib.Menu();
      windowMenu.append_item(new GLib.MenuItem(N_("Hide"), "window.hide"));
      windowMenu.append_item(new GLib.MenuItem(N_("Hide Others"), "window.hide.others"));
      windowMenu.append_item(new GLib.MenuItem(N_("Show All"), "window.showall"));
      menu.append_section(null, windowMenu);

      var otherMenu = new GLib.Menu();
      otherMenu.append_item(new GLib.MenuItem(N_("Quit Application"), "app.quit"));
      menu.append_section(null, otherMenu);

      this._menu_dbus_id = connection.export_menu_model(object_path, menu);

      foreach (var win in this._windows) {
        return_val_if_fail(win.dbus_register(connection, "%s/windows/%lu".printf(object_path, win.id)), false);
      }
      return true;
    }

    public override void dbus_unregister(DBusConnection connection, string object_path) {
      connection.unexport_menu_model(this._menu_dbus_id);

      foreach (var win in this._windows) {
        win.dbus_unregister(connection, "%s/windows/%lu".printf(object_path, win.id));
      }
    }

    public override void startup() {
      base.startup();

      if (this._provider_lib != null) {
        if (this._provider_fn == null) {
          GLib.error("Missing argument \"libtokyo-provider-func\"");
        }

        this._provider = Provider.load_from_path(this._provider_lib, this._provider_fn);
        global_provider = this.provider;

        if (this._provider == null) {
          GLib.error("Failed to load provider %s with %s", this._provider_lib, this._provider_fn);
        }
      } else {
        if (this._provider_fn != null) {
          GLib.error("Missing argument \"libtokyo-provider-lib\"");
        }
      }

      Tokyo.init();
      this.provider.get_application_provider().startup(this);
    }

    public override void shutdown() {
      this.provider.get_application_provider().shutdown(this);
      base.shutdown();
    }

    public virtual signal void window_added(Window win) {}
    public virtual signal void window_removed(Window win) {}
  }
}
