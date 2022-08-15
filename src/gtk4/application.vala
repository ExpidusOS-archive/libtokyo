namespace TokyoGtk {
  public class Application : Adw.Application {
    public Application(string? application_id = null, GLib.ApplicationFlags flags) {
      Object(application_id: application_id, flags: flags);
    }
  }
}
