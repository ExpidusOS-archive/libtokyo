namespace TokyoGtk {
  public class ApplicationWindow : Hdy.ApplicationWindow {
    private Hdy.HeaderBar _header;
    private Gtk.Box _content;

    public Hdy.HeaderBar header {
      get {
        return this.header;
      }
    }

    public ApplicationWindow(Gtk.Application app) {
      Object(application: app);
    }

    construct {
      if (this.title == null || this.title.length == 0) {
        if (this.application != null) this.title = this.application.application_id;
        else this.title = "libtokyo-gtk3-application-window";
      }

      this._content = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
      this._header = new Hdy.HeaderBar();
      this._header.show_close_button = true;
      this._content.pack_start(this._header, false, true, 0);

      this._header.title = this.title;
      this.bind_property("title", this._header, "title", GLib.BindingFlags.SYNC_CREATE | GLib.BindingFlags.BIDIRECTIONAL);

      this.reset_content();
      this._content.show_all();

      this.set_position(Gtk.WindowPosition.MOUSE);
      this.set_gravity(Gdk.Gravity.CENTER);
      this.set_default_size(300, 300);
    }

    public void reset_content() {
      this.child = this._content;
    }

    public Gtk.Box get_box() {
      return this._content;
    }
  }
}
