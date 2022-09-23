namespace TokyoGtk {
  public class Application : Gtk.Application {
    private Gtk.AboutDialog? _about_window;

    public Gtk.AboutDialog? about_window {
      get {
        return this._about_window;
      }
      set {
        this._about_window = value;
      }
    }

    public Application(string? application_id = null, GLib.ApplicationFlags flags) {
      Object(application_id: application_id, flags: flags);
    }

    public override void startup() {
      base.startup();

      var menu = new GLib.Menu();

      var appMenu = new GLib.Menu();
      appMenu.append_item(new GLib.MenuItem("About", "app.about"));
      appMenu.append_item(new GLib.MenuItem("Preferences", "app.preferences"));
      menu.append_section(null, appMenu);

      var windowMenu = new GLib.Menu();
      windowMenu.append_item(new GLib.MenuItem("Hide", "window.hide"));
      windowMenu.append_item(new GLib.MenuItem("Hide Others", "window.hide.others"));
      windowMenu.append_item(new GLib.MenuItem("Show All", "window.showall"));
      menu.append_section(null, windowMenu);

      var otherMenu = new GLib.Menu();
      otherMenu.append_item(new GLib.MenuItem("Quit Application", "app.quit"));
      menu.append_section(null, otherMenu);

      this.set_app_menu(menu);

      var aboutAction = new GLib.SimpleAction("about", null);
      aboutAction.activate.connect(() => {
        if (this.about_window != null) {
          this.about_window.set_application(this);
          this.about_window.set_modal(true);
          this.about_window.set_transient_for(this.get_active_window());

          if (this.about_window.get_visible()) this.about_window.hide();
          else this.about_window.show_all();
        }
      });
      this.add_action(aboutAction);

      var quitAction = new GLib.SimpleAction("quit", null);
      quitAction.activate.connect(() => {
        this.quit();
      });
      this.add_action(quitAction);

      TokyoGtk.init();
      this.init_styling();
    }

    private void update_stylesheet() {}

    private void init_styling() {
      var style_manager = StyleManager.get_default();

      style_manager.hdy.notify["dark"].connect(() => {
        this.update_stylesheet();
      });

      style_manager.hdy.notify["high-contrast"].connect(() => {
        this.update_stylesheet();
      });

      this.update_stylesheet();
    }
  }
}
