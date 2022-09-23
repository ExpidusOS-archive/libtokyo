namespace TokyoGtk {
  public class Window : Hdy.Window {
    private Hdy.HeaderBar _header;
    private Gtk.Box _content;

    public unowned StyleManager style_manager {
      get {
        return StyleManager.get_for_display(this.get_display());
      }
    }

    public Hdy.HeaderBar header {
      get {
        return this.header;
      }
    }
    public Window() {
      Object();
    }

    construct {
      this.get_style_context().add_provider(this.style_manager.provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

      this._content = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
      this._header = new Hdy.HeaderBar();
      this._header.show_close_button = true;
      this._content.pack_start(this._header, false, true, 0);

      this.reset_content();
      this.set_default_size(300, 300);
    }

    public void reset_content() {
      this.child = this._content;
    }

    public Gtk.Box get_box() {
      return this._content;
    }

    public override void map() {
      base.map();

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
