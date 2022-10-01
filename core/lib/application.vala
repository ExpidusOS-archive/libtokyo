namespace Tokyo {
  /**
   * Provider for Applications
   */
  public interface ApplicationProvider : GLib.Object {
    public abstract void startup(GLib.Application app);
  }

  /**
   * Application class
   */
  public abstract class Application : GLib.Application {
    private uint _menu_dbus_id;
    private Provider? _provider;

    public Provider provider {
      get {
        if (this._provider == null) this._provider = Provider.get_global();
        return this._provider;
      }
      set construct {
        this._provider = value;
      }
    }
    
    private int _command_line(GLib.ApplicationCommandLine cmdline) {
      string? provider_fn = null;
      string? provider_lib = null;

      GLib.OptionEntry[] options = {
        { "libtokyo-provider-func", '\0', GLib.OptionFlags.NONE, GLib.OptionArg.STRING, ref provider_fn, N_("The GLib get_type function to use for the provider"), "FUNC" },
        { "libtokyo-provider-lib", '\0', GLib.OptionFlags.NONE, GLib.OptionArg.FILENAME, ref provider_lib, N_("The path to the library to use for loading libtokyo"), "LIB" },
        { null }
      };

      string[] args = cmdline.get_arguments();
      string*[] _args = new string[args.length];
      for (int i = 0; i < args.length; i++) _args[i] = args[i];

      try {
        var group = new GLib.OptionGroup("libtokyo", N_("libtokyo Options"), N_("Show all options for the libtokyo library"));
        group.add_entries(options);

        var optctx = this.create_option_context();
        optctx.add_group(group);

        unowned string[] tmp = _args;
        optctx.parse(ref tmp);
      } catch (GLib.OptionError e) {
        cmdline.printerr("%s: failed to handle arguments: %s:%d: %s", args[0], e.domain.to_string(), e.code, e.message);
        return 1;
      }

      if (provider_lib != null) {
        if (provider_fn == null) {
          cmdline.printerr("%s: missing argument \"libtokyo-provider-func\"", args[0]);
          return 1;
        }

        this._provider = Provider.load_from_path(provider_lib, provider_fn);
        global_provider = this.provider;

        if (this._provider == null) {
          cmdline.printerr("%s: failed to load provider %s with %s", args[0], provider_lib, provider_fn);
          return 1;
        }
      } else {
        if (provider_fn != null) {
          cmdline.printerr("%s: missing argument \"libtokyo-provider-lib\"", args[0]);
          return 1;
        }
      }
      return 0;
    }

    public override int command_line(GLib.ApplicationCommandLine cmdline) {
      this.hold();
      int res = this._command_line(cmdline);
      this.release();
      return res;
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
      return true;
    }

    public override void dbus_unregister(DBusConnection connection, string object_path) {
      connection.unexport_menu_model(this._menu_dbus_id);
    }

    public override void startup() {
      base.startup();
      Tokyo.init();
    }

    public virtual GLib.OptionContext create_option_context() {
      var optctx = new GLib.OptionContext(null);
      optctx.set_help_enabled(true);
      return optctx;
    }
  }
}
