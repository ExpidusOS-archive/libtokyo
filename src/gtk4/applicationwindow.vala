namespace TokyoGtk {
  public class ApplicationWindow : Adw.ApplicationWindow {
    public ApplicationWindow(Gtk.Application app) {
      Object(application: app);
    }

    construct {
      var app = this.application as TokyoGtk.Application;
      GLib.return_if_fail(app != null);

      var style_context = this.get_style_context();

      var style_provider = new Gtk.CssProvider();
      if (app.style_manager.dark) style_provider.load_from_resource("/com/expidus/tokyogtk/gtk-default.css");
      else style_provider.load_from_resource("/com/expidus/tokyogtk/gtk-light.css");

      style_context.add_provider(style_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    }
  }
}
