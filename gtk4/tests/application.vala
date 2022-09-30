public static int main(string[] args) {
  Gtk.test_init(ref args);
  TokyoGtk.init();

  GLib.Test.add_func("/gtk/application/new", () => {
    var app = new TokyoGtk.Application("com.expidus.libtokyo.gtk.test", GLib.ApplicationFlags.FLAGS_NONE);
    assert_nonnull(app);
  });
  return GLib.Test.run();
}
