namespace TokyoGTKExample {
  public class MainWindow : TokyoGtk.ApplicationWindow {
    public TokyoGtk.CalendarEvents calevents { get; }

    public MainWindow(Gtk.Application app) {
      Object(application: app);
    }

    construct {
      this._calevents = new TokyoGtk.CalendarEvents();
      this.get_box().append(this._calevents);
    }
  }

  public class MainApplication : TokyoGtk.Application {
    public MainApplication() {
      Object(application_id: "com.expidus.gtk4.tokyo.example", flags: GLib.ApplicationFlags.FLAGS_NONE);
    }

    public override void activate() {
      base.activate();

      if (this.get_windows().length() == 0) {
        var win = new MainWindow(this);
        this.add_window(win);
        win.show();
      } else {
        this.get_windows().nth_data(0).show();
      }
    }
  }
}

public static int main(string[] args) {
  return new TokyoGTKExample.MainApplication().run(args);
}
