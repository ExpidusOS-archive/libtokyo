namespace TokyoGTKExample {
  public class MainWindow : Tokyo.ApplicationWindow {
    public MainWindow(Tokyo.Application app) {
      Object(application: app);
    }
  }

  public class MainApplication : Tokyo.Application {
    public MainApplication() {
      Object(application_id: "com.expidus.tokyo.example", flags: GLib.ApplicationFlags.FLAGS_NONE);
    }

    public override void activate() {
      base.activate();

      if (this.get_windows().length() == 0) {
        var win = new MainWindow(this);
        this.add_window(win);
        win.show();
      } else {
        this.get_windows().nth_data(0).show();
      }

      this.hold();
    }
  }
}

public static int main(string[] args) {
  return new TokyoGTKExample.MainApplication().run(args);
}
