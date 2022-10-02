namespace TokyoGtk {
  internal static uint next_window_id = 1;

  public interface BaseWindow : Gtk.Window {
    public abstract uint id { get; }
    public abstract Provider? provider { get; construct; }
    public abstract Adw.HeaderBar header { get; }

    internal void init() {
      var provider = this.provider != null ? this.provider : Tokyo.Provider.get_global();
      assert(provider != null);

      var style_manager_provider = provider.get_style_manager_provider() as StyleManagerProvider;
      assert(style_manager_provider != null);

      var style_manager = style_manager_provider.get_for_display(this.get_display());
      assert(style_manager != null);

      var style_manager_data = style_manager_provider._managers.get(style_manager);
      assert(style_manager_data != null);

      this.get_style_context().add_provider(style_manager_data.provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

      this.decorated = false;
      this.get_box().append(this.header);

      this.reset_content();
      this.set_default_size(300, 300);
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

        base_win.show();
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

  public class Window : Adw.Window, BaseWindow {
    private Adw.HeaderBar _header;
    private Gtk.Box _content;
    private uint _id;
    private Provider? _provider;

    public Adw.HeaderBar header {
      get {
        return this._header;
      }
    }

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

    public Window() {
      Object();
    }

    construct {
      this._content = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
      this._header  = new Adw.HeaderBar();

      this.init();
    }

    public void reset_content() {
      this.set_content(this._content);
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
