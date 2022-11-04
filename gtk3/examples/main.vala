namespace TokyoGTKExample {
  public class MainWindow : TokyoGtk.ApplicationWindow {
    public TokyoGtk.CalendarEvents calevents { get; }

    public MainWindow(Gtk.Application app) {
      Object(application: app);
    }

    construct {
      this._calevents = new TokyoGtk.CalendarEvents();
      this.get_box().add(this._calevents);

      var list = new GLib.ListStore(typeof (ICal.Component));

      list.append(new ICal.Component.from_string("""
BEGIN:VEVENT
DTSTART:20970714T170000Z
DTEND:20970715T035959Z
SUMMARY:Hello, world
DESCRIPTION:An event is in the calendar.
END:VEVENT
"""));

      list.append(new ICal.Component.from_string("""
BEGIN:VEVENT
DTSTART:19970714T170000Z
DTEND:19970715T035959Z
SUMMARY:Bastille Day Party
END:VEVENT
"""));

      this._calevents.events_list.bind_model(list);
    }
  }

  public class MainApplication : TokyoGtk.Application {
    public MainApplication() {
      Object(application_id: "com.expidus.gtk3.tokyo.example", flags: GLib.ApplicationFlags.FLAGS_NONE);
    }

    public override void activate() {
      base.activate();

      if (this.get_windows().length() == 0) {
        var win = new MainWindow(this);
        this.add_window(win);
        win.show_all();
      } else {
        this.get_windows().nth_data(0).show();
      }
    }
  }
}

public static int main(string[] args) {
  return new TokyoGTKExample.MainApplication().run(args);
}
