namespace TokyoGtk {
  public class ApplicationProvider : GLib.Object, Tokyo.ApplicationProvider {
    internal ApplicationProvider() {
      Object();
    }

    public void startup(Tokyo.Application application) {}

    public void shutdown(Tokyo.Application application) {}
  }

  public class Application : Adw.Application {
    private Gtk.AboutDialog _about_window;

    public Gtk.AboutDialog about_window {
      get {
        return this._about_window;
      }
      set {
        this._about_window = value;
      }
    }

    public Application(string ?application_id = null, GLib.ApplicationFlags flags) {
      Object(application_id: application_id, flags: flags);
    }

    public override void startup() {
      base.startup();

      TokyoGtk.init();
    }
  }
}
