namespace TokyoGtk {
  public class Application : Gtk.Application {
    public Application(string? application_id = null, GLib.ApplicationFlags flags) {
      Object(application_id: application_id, flags: flags);
    }

    public override void startup() {
      base.startup();

      TokyoGtk.init();
      this.init_styling();
    }

    private void update_stylesheet() {}

    private void init_styling() {
      var style_manager = StyleManager.get_default();

      style_manager.hdy.notify["dark"].connect(() => {
        this.update_stylesheet();
      });

      style_manager.hdy.notify["high-contrast"].connect(() => {
        this.update_stylesheet();
      });

      this.update_stylesheet();
    }
  }
}
