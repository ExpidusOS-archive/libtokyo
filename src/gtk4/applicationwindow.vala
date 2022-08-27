namespace TokyoGtk {
  public class ApplicationWindow : Adw.ApplicationWindow {
    public ApplicationWindow(Gtk.Application app) {
      Object(application: app);
    }
  }
}
