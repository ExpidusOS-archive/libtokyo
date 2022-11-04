namespace TokyoGtk {
  public class EventRow : Hdy.ExpanderRow {
    private Gtk.Label _timespan;
    private ICal.Component _component;

    public ICal.Component component {
      get {
        return this._component;
      }
      set construct {
        this._component = value;
        this.update();
      }
    }

    public GLib.DateTime start {
      owned get {
        var tz = new GLib.TimeZone.local().get_identifier();
        var ictz = ICal.Timezone.get_builtin_timezone_from_tzid(tz);
        var span = this.component.get_span();
        return this.dt_from_ical(new ICal.Time.from_timet_with_zone(span.get_start(), 0, ictz));
      }
    }

    public GLib.DateTime end {
      owned get {
        var tz = new GLib.TimeZone.local().get_identifier();
        var ictz = ICal.Timezone.get_builtin_timezone_from_tzid(tz);
        var span = this.component.get_span();
        return this.dt_from_ical(new ICal.Time.from_timet_with_zone(span.get_end(), 0, ictz));
      }
    }

    public bool is_same_day {
      get {
        return this.is_same_year && this.start.get_day_of_year() == this.end.get_day_of_year() && this.start.get_day_of_year() == this.datetime.get_day_of_year();
      }
    }

    public bool is_same_month {
      get {
        return this.is_same_year && this.start.get_month() == this.end.get_month() && this.start.get_month() == this.datetime.get_month();
      }
    }

    public bool is_same_year {
      get {
        return this.start.get_year() == this.end.get_year() && this.start.get_year() == this.datetime.get_year();
      }
    }

    public GLib.DateTime datetime { get; set construct; }

    public EventRow(ICal.Component component, GLib.DateTime? datetime = null) {
      Object(component: component, datetime: datetime);
    }

    construct {
      if (this._datetime == null) this._datetime = new GLib.DateTime.now_local();

      this._timespan = new Gtk.Label("");
      this.add_prefix(this._timespan);
      this.update();
    }

    private void update() {
      this.update_timespan();
      this.update_title();
    }

    private GLib.DateTime dt_from_ical(ICal.Time time) {
      GLib.TimeZone tz;
      try {
        tz = new GLib.TimeZone.identifier(time.get_tzid());
      } catch (GLib.Error e) {
        tz = new GLib.TimeZone.local();
      }

      return new GLib.DateTime(tz, time.get_year(), time.get_month(), time.get_day(), time.get_hour(), time.get_minute(), time.get_second() * 1.0);
    }

    private void update_timespan() {
      if (this._timespan == null) return;

      if (this.is_same_day) {
        this._timespan.label = _("%s - %s").printf(start.format("%X"), end.format("%X"));
      } else if (this.is_same_month) {
        this._timespan.label = _("%s - %s").printf(start.format(_("%a %d %X")), end.format(_("%a %d %X")));
      } else if (this.is_same_year) {
        this._timespan.label = _("%s - %s").printf(start.format(_("%b, %a %d %X")), end.format(_("%b, %a %d %X")));
      } else {
        this._timespan.label = _("%s - %s").printf(start.format(_("%Y %b, %a %d %X")), end.format(_("%Y %b, %a %d %X")));
      }
    }

    private void update_title() {
      var summary = this.component.get_summary();
      var description = this.component.get_description();

      this.title = summary == null ? description : summary;
      if (summary != null && description != null) this.subtitle = description;
    }
  }
}
