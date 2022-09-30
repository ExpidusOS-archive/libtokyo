public static int main(string[] args) {
  Gtk.test_init(ref args);
  TokyoGtk.init();

  GLib.Test.add_func("/gtk/applicationwindow/new", () => {
    var win = new TokyoGtk.ApplicationWindow(null);
    assert_nonnull(win);
  });
  return GLib.Test.run();
}
