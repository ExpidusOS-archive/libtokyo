namespace TokyoGtk {
  internal static uint next_window_id = 1;

  public interface BaseWindow : Gtk.Window {
    public abstract uint id { get; }
    public abstract Provider? provider { get; construct; }
    public abstract Hdy.HeaderBar header { get; }

    public Tokyo.StyleManager style_manager {
      get {
        var provider = this.provider != null ? this.provider : Tokyo.Provider.get_global();
        assert(provider != null);

        var style_manager_provider = provider.get_style_manager_provider() as StyleManagerProvider;
        assert(style_manager_provider != null);

        return style_manager_provider.get_for_display(this.get_display());
      }
    }

    internal void init() {
      if (this.title == null || this.title.length == 0) {
        if (this.application != null) {
          this.title = this.application.application_id;
        } else {
          if (this is Gtk.ApplicationWindow) {
            this.title = "libtokyo-gtk3-application-window";
          } else {
            this.title = "libtokyo-gtk3-window";
          }
        }
      }

      var provider = this.provider != null ? this.provider : Tokyo.Provider.get_global();
      assert(provider != null);

      var style_manager_provider = provider.get_style_manager_provider() as StyleManagerProvider;
      assert(style_manager_provider != null);

      var style_manager_data = style_manager_provider._managers.get(this.style_manager);
      assert(style_manager_data != null);

      this.get_style_context().add_provider(style_manager_data.provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

      this.decorated = false;
      this.set_position(Gtk.WindowPosition.MOUSE);
      this.set_gravity(Gdk.Gravity.CENTER);
      this.set_default_size(300, 300);

      this.header.show_close_button = true;
      this.get_box().pack_start(this.header, false, true, 0);

      this.reset_content();
      this.get_box().show_all();

      this.header.title = this.title;
      this.bind_property("title", this.header, "title", GLib.BindingFlags.SYNC_CREATE | GLib.BindingFlags.BIDIRECTIONAL);
    }

    public abstract void reset_content();
    public abstract Gtk.Box get_box();
  }

  public class WindowProvider : GLib.Object, Tokyo.WindowProvider {
    private const string OBJECT_DATA_KEY = "TokyoGtkWindow";

    private GLib.HashTable<Tokyo.Window, BaseWindow> _windows;

    construct {
      this._windows = new GLib.HashTable<Tokyo.Window, BaseWindow>((k) => k.id, (a, b) => {
        if (a == null && b == null) return false;
        return a.id == b.id;
      });

      this.map.connect((win) => {
        var base_win = win.get_data<BaseWindow>(OBJECT_DATA_KEY);
        assert(base_win != null);

        base_win.map();
      });

      this.unmap.connect((win) => {
        var base_win = win.get_data<BaseWindow>(OBJECT_DATA_KEY);
        assert(base_win != null);

        base_win.unmap();
      });

      this.show.connect((win) => {
        var base_win = win.get_data<BaseWindow>(OBJECT_DATA_KEY);
        assert(base_win != null);

        base_win.show_all();
      });

      this.hide.connect((win) => {
        var base_win = win.get_data<BaseWindow>(OBJECT_DATA_KEY);
        assert(base_win != null);

        base_win.hide();
      });
    }

    public uint get_id(Tokyo.Window win) {
      var base_win = win.get_data<BaseWindow>(OBJECT_DATA_KEY);
      return base_win == null ? -1 : base_win.id;
    }

    private void finish_create(Tokyo.Window win) {
      var base_win = win.get_data<BaseWindow>(OBJECT_DATA_KEY);
      assert(base_win != null);

      base_win.map.connect(() => { win.map(); });
      base_win.unmap.connect(() => { win.unmap(); });
      base_win.show.connect(() => { win.show(); });
      base_win.hide.connect(() => { win.hide(); });
    }

    public void create(Tokyo.Window win) {
      if (win is Tokyo.ApplicationWindow) {
        var app_win = win as Tokyo.ApplicationWindow;
        if (app_win != null) {
          var base_win = new ApplicationWindow(null);
          win.set_data(OBJECT_DATA_KEY, base_win);
          this._windows.set(win, base_win);
          this.finish_create(win);
          return;
        }
      }

      var base_win = new Window();
      win.set_data(OBJECT_DATA_KEY, base_win);
      this._windows.set(win, base_win);
      this.finish_create(win);
    }

    public void destroy(Tokyo.Window win) {
      this._windows.remove(win);
    }
  }

  public class Window : Hdy.Window, BaseWindow {
    private Hdy.HeaderBar _header;
    private Gtk.Box _content;
    private uint _id;
    private Provider? _provider;

    public uint id {
      get {
        if (this._id == 0) this._id = next_window_id++;
        return this._id;
      }
    }
    
    public Provider? provider {
      get {
        return this._provider;
      }
      construct {
        this._provider = value;
      }
    }

    public Hdy.HeaderBar header {
      get {
        return this._header;
      }
    }

    public Window() {
      Object();
    }

    construct {
      this._content = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
      this._header  = new Hdy.HeaderBar();

      this.init();
    }

    public void reset_content() {
      this.child = this._content;
    }

    public Gtk.Box get_box() {
      return this._content;
    }

    public override void map() {
      base.map();

      TokyoGtk.init();
    }
  }
}
