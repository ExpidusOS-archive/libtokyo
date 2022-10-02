namespace TokyoGtk {
  public class ApplicationProvider : GLib.Object, Tokyo.ApplicationProvider {
    internal ApplicationProvider() {
      Object();
    }

    public void startup(Tokyo.Application application) {}

    public void shutdown(Tokyo.Application application) {}
  }

  public class Application : Gtk.Application {
    private Gtk.AboutDialog ?_about_window;

    public Gtk.AboutDialog ?about_window {
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

      var aboutAction = new GLib.SimpleAction("about", null);
      aboutAction.activate.connect(() => {
        if (this.about_window != null) {
          this.about_window.set_application(this);
          this.about_window.set_modal(true);
          this.about_window.set_transient_for(this.get_active_window());

          if (this.about_window.get_visible()) {
            this.about_window.hide();
          }else{
            this.about_window.show_all();
          }
        }
      });
      this.add_action(aboutAction);

      var quitAction = new GLib.SimpleAction("quit", null);
      quitAction.activate.connect(() => {
        this.quit();
      });
      this.add_action(quitAction);

      TokyoGtk.init();

      var style_manager_provider = Tokyo.Provider.get_global().get_style_manager_provider() as StyleManagerProvider;
      assert(style_manager_provider != null);

      style_manager_provider.ensure();
    }
  }
}
