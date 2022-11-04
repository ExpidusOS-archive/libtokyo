namespace TokyoGtk {
  public class EventsList : Gtk.ListBox {
    private Gtk.Label _placeholder;
    public GLib.DateTime datetime { get; set construct; }

    public EventsList(GLib.DateTime? datetime = null) {
      Object(datetime: datetime);
    }

    class construct {
      set_css_name("eventslist");
    }

    construct {
      if (this._datetime == null) this._datetime = new GLib.DateTime.now_local();

      this.set_filter_func((_row) => {
        var row = _row as EventRow;
        if (row == null) return false;
        return row.is_same_day;
      });

      this.set_sort_func((_a, _b) => {
        var a = _a as EventRow;
        var b = _b as EventRow;

        if (a == null) return 0;
        if (b == null) return 0;
        return a.start.compare(b.start);
      });

      this._placeholder = new Gtk.Label(_("You have no events for %s.").printf(this.datetime.format("%x")));
      this._placeholder.halign = Gtk.Align.CENTER;
      this._placeholder.valign = Gtk.Align.CENTER;
      this._placeholder.show();
      this.set_placeholder(this._placeholder);

      this.notify["datetime"].connect(() => {
        this._placeholder.label = _("You have no events for %s.").printf(this.datetime.format("%x"));
      });
    }

    private EventRow create(ICal.Component component) {
      var row = new EventRow(component, this.datetime);
      row.bind_property("datetime", this, "datetime", GLib.BindingFlags.BIDIRECTIONAL | GLib.BindingFlags.SYNC_CREATE);
      return row;
    }

    public new void bind_model(GLib.ListModel? model) {
      assert(model.get_item_type() == typeof (ICal.Component));
      base.bind_model(model, (item) => this.create((ICal.Component)item));
    }

    public new void insert(ICal.Component component, int pos) {
      base.insert(this.create(component), pos);
    }

    public new void prepend(ICal.Component component) {
      base.prepend(this.create(component));
    }
  }
}
