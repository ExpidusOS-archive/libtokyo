public static int main(string[] args) {
  Gtk.test_init(ref args);
  TokyoGtk.init();

  GLib.Test.add_func("/gtk/window/new", () => {
    var win = new TokyoGtk.Window();
    assert_nonnull(win);
  });
  return GLib.Test.run();
}
