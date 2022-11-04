namespace TokyoGtk {
  public class Calendar : Gtk.Calendar {
    public GLib.DateTime datetime { get; set construct; }

    public Calendar(GLib.DateTime? datetime = null) {
      Object(datetime: datetime);
    }

    construct {
      if (this._datetime == null) this.datetime = new GLib.DateTime.now_local();

      this.notify["year"].connect(() => this.update_year());
      this.notify["month"].connect(() => this.update_month());
      this.notify["day"].connect(() => this.update_day());

      this.notify["datetime"].connect(() => this.update());

      this.update();
    }

    private void update() {
      this.year = this.datetime.get_year();
      this.month = this.datetime.get_month() - 1;
      this.day = this.datetime.get_day_of_month();
    }

    private void update_year() {
      this.datetime = new GLib.DateTime(this.datetime.get_timezone(), this.year, this.datetime.get_month(), this.datetime.get_day_of_month(), this.datetime.get_hour(), this.datetime.get_minute(), this.datetime.get_seconds());
    }

    private void update_month() {
      this.datetime = new GLib.DateTime(this.datetime.get_timezone(), this.datetime.get_year(), this.month + 1, this.datetime.get_day_of_month(), this.datetime.get_hour(), this.datetime.get_minute(), this.datetime.get_seconds());
    }

    private void update_day() {
      this.datetime = new GLib.DateTime(this.datetime.get_timezone(), this.datetime.get_year(), this.datetime.get_month(), this.day, this.datetime.get_hour(), this.datetime.get_minute(), this.datetime.get_seconds());
    }
  }
}
