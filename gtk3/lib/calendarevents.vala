namespace TokyoGtk {
  public class CalendarEvents : Gtk.Box {
    private Hdy.ViewSwitcherTitle _title;
    private Gtk.Stack _stack;

    public GLib.DateTime datetime { get; set construct; }

    public Gtk.Calendar calendar { get; }
    public EventsList events_list { get; }

    public CalendarEvents(GLib.DateTime? datetime = null) {
      Object(datetime: datetime);
    }

    class construct {
      set_css_name("calendarevents");
    }

    construct {
      if (this._datetime == null) this._datetime = new GLib.DateTime.now_local();

      this.orientation = Gtk.Orientation.VERTICAL;
      this.spacing = 10;

      this._title = new Hdy.ViewSwitcherTitle();
      this._title.get_style_context().add_class("title");
      this._title.title = _("Calendar");
      this.add(this._title);

      this._stack = new Gtk.Stack();
      this._stack.get_style_context().add_class("stack");
      this._stack.hexpand = true;
      this._stack.vexpand = true;
      this._title.stack = this._stack;
      this.add(this._stack);

      this._calendar = new Calendar(this.datetime);
      this._calendar.bind_property("datetime", this, "datetime", GLib.BindingFlags.BIDIRECTIONAL | GLib.BindingFlags.SYNC_CREATE);
      this._calendar.get_style_context().add_class("calendar");
      this._calendar.hexpand = true;
      this._calendar.vexpand = true;
      this._stack.add_titled(this._calendar, "calendar", _("Calendar"));

      this._events_list = new EventsList(this.datetime);
      this._events_list.bind_property("datetime", this, "datetime", GLib.BindingFlags.BIDIRECTIONAL | GLib.BindingFlags.SYNC_CREATE);
      this._events_list.get_style_context().add_class("events");
      this._events_list.hexpand = true;
      this._events_list.vexpand = true;
      this._stack.add_titled(this._events_list, "events", _("Events"));
    }
  }
}
