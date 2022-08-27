namespace TokyoGtk {
  public class Window : Adw.Window {
    public override void map() {
      base.map();

      TokyoGtk.init();
      this.init_styling();
    }

    private void update_stylesheet() {}

    private void init_styling() {
      var style_manager = StyleManager.get_default();

      style_manager.adw.notify["dark"].connect(() => {
        this.update_stylesheet();
      });

      style_manager.adw.notify["high-contrast"].connect(() => {
        this.update_stylesheet();
      });

      this.update_stylesheet();
    }
  }
}
