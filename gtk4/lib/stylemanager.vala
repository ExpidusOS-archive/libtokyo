namespace TokyoGtk {
  internal class StyleManagerData {
    internal Gtk.CssProvider provider;
    internal Adw.StyleManager adw;
    internal Gdk.Display display;

    internal StyleManagerData(Gdk.Display display) {
      this.display = display;

      if (this.display != null) {
        this.adw = Adw.StyleManager.get_for_display(this.display);

        if (GLib.Environment.get_variable("GTK_THEME") == null) {
          this.provider = new Gtk.CssProvider();
          Gtk.StyleContext.add_provider_for_display(this.display, this.provider, Gtk.STYLE_PROVIDER_PRIORITY_THEME);
        }

        this.adw.notify["color-scheme"].connect(() => {
          this.update_stylesheet();
        });

        this.adw.notify["high-contrast"].connect(() => {
          this.update_stylesheet();
        });

        GLib.debug("registering for display %s", this.display.get_name());
      }

      this.update_stylesheet();
    }

    internal Tokyo.ColorScheme get_color_scheme() {
      if (this.adw.high_contrast) return Tokyo.ColorScheme.STORM;
      switch (this.adw.color_scheme) {
        case Adw.ColorScheme.DEFAULT:
        case Adw.ColorScheme.FORCE_DARK:
        case Adw.ColorScheme.PREFER_DARK:
          return Tokyo.ColorScheme.NIGHT;

        default: return Tokyo.ColorScheme.LIGHT;
      }
    }

    internal void update_stylesheet() {
      if (this.provider != null) {
        switch (this.get_color_scheme()) {
        case Tokyo.ColorScheme.NIGHT:
          GLib.debug("Using night theme on display %s", this.display.get_name());
          this.provider.load_from_resource("/com/expidus/tokyogtk/gtk-default.css");
          break;

        case Tokyo.ColorScheme.LIGHT:
          GLib.debug("Using light theme on display %s", this.display.get_name());
          this.provider.load_from_resource("/com/expidus/tokyogtk/gtk-light.css");
          break;

        case Tokyo.ColorScheme.STORM:
          GLib.debug("Using storm theme on display %s", this.display.get_name());
          this.provider.load_from_resource("/com/expidus/tokyogtk/gtk-storm.css");
          break;
        }
      }
    }
  }

  public class StyleManagerProvider : GLib.Object, Tokyo.StyleManagerProvider {
    internal GLib.HashTable<Tokyo.StyleManager, StyleManagerData?> _managers;
    private Tokyo.Provider _provider;

    public Tokyo.Provider provider {
      get {
        return this._provider;
      }
      construct {
        this._provider = value;
      }
    }
    
    internal StyleManagerProvider(Tokyo.Provider provider) {
      Object(provider: provider);
    }

    construct {
      this._managers = new GLib.HashTable<Tokyo.StyleManager, StyleManagerData?>(GLib.direct_hash, GLib.direct_equal);
    }

    internal unowned Tokyo.StyleManager? get_for_display(Gdk.Display display) {
      foreach (var key in this._managers.get_keys()) {
        unowned var data = this._managers.get(key);
        if (data.display.get_name() == display.get_name()) {
          return key;
        }
      }
      return null;
    }

    private void register_display(Gdk.Display display) {
      if (this.get_for_display(display) == null) {
        var data = new StyleManagerData(display);
        var key = new Tokyo.StyleManager.with_provider(this.provider);
        this._managers.insert(key, data);
      }
    }

    public unowned Tokyo.StyleManager? get_default() {
      return this.get_for_display(Gdk.DisplayManager.@get().get_default_display());
    }

    public void ensure() {
      var display_manager = Gdk.DisplayManager.@get();

      display_manager.list_displays().@foreach((display) => {
        this.register_display(display);
      });

      display_manager.display_opened.connect((display) => {
        this.register_display(display);
      });
    }

    public void create(Tokyo.StyleManager style_manager) {
      var data = this._managers.get(style_manager);
      if (data == null) return;
    }

    public void destroy(Tokyo.StyleManager style_manager) {
      var data = this._managers.get(style_manager);
      if (data == null) return;

      this._managers.remove(style_manager);
    }

    public Tokyo.ColorScheme get_color_scheme(Tokyo.StyleManager style_manager) {
      var data = this._managers.get(style_manager);
      if (data == null) return Tokyo.ColorScheme.NIGHT;
      return data.get_color_scheme();
    }
  }
}
