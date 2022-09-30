namespace TokyoGtk {
private StyleManager global_style_manager;
private GLib.HashTable <Gdk.Display, StyleManager> display_style_managers;

public enum ColorScheme {
  NIGHT = 0,
  LIGHT,
  STORM
}

public sealed class StyleManager : GLib.Object {
  private Gtk.CssProvider _provider;
  private Hdy.StyleManager _hdy;
  private Gdk.Display _display;

  public Gtk.CssProvider ?provider {
    get {
      return this._provider;
    }
  }

  public Hdy.StyleManager hdy {
    get {
      return this._hdy;
    }
  }

  public ColorScheme color_scheme {
    get {
      var color = GLib.Environment.get_variable("TOKYO_COLOR");
      if (color != null) {
        if (color == "night" || color == "default") {
          return ColorScheme.NIGHT;
        }
        if (color == "light") {
          return ColorScheme.LIGHT;
        }
        if (color == "storm") {
          return ColorScheme.STORM;
        }
      }

      if (this.hdy.high_contrast) {
        return ColorScheme.STORM;
      }

      switch (this.hdy.color_scheme) {
      case Hdy.ColorScheme.DEFAULT:
      case Hdy.ColorScheme.FORCE_DARK:
      case Hdy.ColorScheme.PREFER_DARK:
        return ColorScheme.NIGHT;

      default: return ColorScheme.LIGHT;
      }
    }
  }

  public Gdk.Display display {
    get {
      return this._display;
    }
    construct {
      this._display = value;
    }
  }

  public static unowned StyleManager get_default() {
    return global_style_manager;
  }

  public static unowned StyleManager get_for_display(Gdk.Display display) {
    if (display_style_managers == null) {
      display_style_managers = new GLib.HashTable <Gdk.Display, StyleManager>(GLib.direct_hash, GLib.direct_equal);
    }
    return display_style_managers.get(display);
  }

  private static void register_display(Gdk.Display display) {
    if (display_style_managers == null) {
      display_style_managers = new GLib.HashTable <Gdk.Display, StyleManager>(GLib.direct_hash, GLib.direct_equal);
    }
    if (!display_style_managers.contains(display)) {
      display_style_managers.insert(display, new StyleManager(display));

      display.closed.connect(() => {
          display_style_managers.remove(display);
        });
    }
  }

  public static void ensure() {
    if (display_style_managers == null) {
      display_style_managers = new GLib.HashTable <Gdk.Display, StyleManager>(GLib.direct_hash, GLib.direct_equal);
    }
    var display_manager = Gdk.DisplayManager.@get();

    display_manager.list_displays().@foreach((display) => {
        register_display(display);
      });

    display_manager.display_opened.connect((display) => {
        register_display(display);
      });

    global_style_manager = display_style_managers.get(display_manager.get_default_display());
  }

  private StyleManager(Gdk.Display display) {
    Object(display: display);
  }

  construct {
    if (this.display != null) {
      this._hdy = Hdy.StyleManager.get_for_display(this.display);

      if (GLib.Environment.get_variable("GTK_THEME") == null) {
        var gtk_settings = Gtk.Settings.get_for_screen(this.display.get_default_screen());

        gtk_settings.gtk_theme_name = "Tokyo-empty";

        this._provider = new Gtk.CssProvider();
        Gtk.StyleContext.add_provider_for_screen(this.display.get_default_screen(), this.provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
      }

      this.hdy.notify["color-scheme"].connect(() => {
          this.update_stylesheet();
        });

      this.hdy.notify["high-contrast"].connect(() => {
          this.update_stylesheet();
        });

      GLib.debug("registering for display %s", this.display.get_name());
    }

    this.update_stylesheet();
  }

  private void update_stylesheet() {
    if (this.provider != null) {
      switch (this.color_scheme) {
      case ColorScheme.NIGHT:
        this.provider.load_from_resource("/com/expidus/tokyogtk/gtk-default.css");
        break;

      case ColorScheme.LIGHT:
        this.provider.load_from_resource("/com/expidus/tokyogtk/gtk-light.css");
        break;

      case ColorScheme.STORM:
        this.provider.load_from_resource("/com/expidus/tokyogtk/gtk-storm.css");
        break;
      }
    }
  }
}
}
