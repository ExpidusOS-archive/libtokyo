namespace TokyoGtk {
  public sealed class Provider : Tokyo.Provider {
    public override void init(Vdi.Container container) {
      unowned string[] args = null;
      Gtk.init(ref args);
      container.bind_type(typeof (Tokyo.ApplicationProvider), typeof (TokyoGtk.ApplicationProvider));
      container.bind_factory(typeof (Tokyo.StyleManagerProvider), () => {
        return new TokyoGtk.StyleManagerProvider(this);
      });
    }
  }
}
